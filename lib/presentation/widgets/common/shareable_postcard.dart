import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/design_system.dart';
import '../../../data/models/pine_cone_model.dart';
import '../../../data/models/species_model.dart';

class ShareablePostcard extends StatefulWidget {
  final PineConeModel cone;
  final SpeciesModel? species;
  final Widget child; // The UI button/content to trigger the share

  const ShareablePostcard({
    super.key,
    required this.cone,
    this.species,
    required this.child,
  });

  @override
  State<ShareablePostcard> createState() => ShareablePostcardState();
}

class ShareablePostcardState extends State<ShareablePostcard> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isSharing = false;

  Future<void> sharePostcard() async {
    if (_isSharing) return;
    
    setState(() => _isSharing = true);
    
    try {
      // 1. Wait a frame to ensure boundary is rendered
      await Future.delayed(const Duration(milliseconds: 50));
      
      // 2. Capture the image
      final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      
      final buffer = byteData.buffer;

      // 3. Save to temp file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/strobilus_postcard_${widget.cone.id}.png').create();
      await file.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );

      // 4. Share
      final xfile = XFile(file.path, mimeType: 'image/png');
      final text = widget.species != null
          ? 'Regarde cette magnifique ${widget.species!.getCommonName(Localizations.localeOf(context).languageCode)} trouvée via Strobilus ! 🌲'
          : 'Regarde ma nouvelle trouvaille via Strobilus ! 🌲';
          
      await Share.shareXFiles([xfile], text: text);
    } catch (e) {
      debugPrint('Error sharing postcard: $e');
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: sharePostcard,
      child: Stack(
        children: [
          // The visible child that the user taps
          widget.child,
          
          // The hidden postcard layout to be captured
          Positioned(
            left: -9999, // Render off-screen
            child: RepaintBoundary(
              key: _globalKey,
              child: _PostcardLayout(
                cone: widget.cone,
                species: widget.species,
              ),
            ),
          ),
          
          // Loading overlay on the child if sharing
          if (_isSharing)
            Positioned.fill(
              child: Container(
                color: Colors.white.withValues(alpha: 0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PostcardLayout extends StatelessWidget {
  final PineConeModel cone;
  final SpeciesModel? species;

  const _PostcardLayout({
    required this.cone,
    this.species,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat.yMMMd().format(cone.collectedAt);

    return Container(
      width: 1080 / 2, // Instagram story ratio approx (1080x1920) divided for screen rendering
      height: 1920 / 2,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Midnight Dark
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          if (cone.photoUrls.isNotEmpty)
            Image.file(
              File(cone.photoUrls.first),
              fit: BoxFit.cover,
            )
          else
            Container(color: theme.colorScheme.primary),
            
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(DS.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top: App Logo/Branding
                Row(
                  children: [
                    const Icon(Icons.park, color: Colors.white, size: 32),
                    const SizedBox(width: DS.sm),
                    Text(
                      'STROBILUS',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                
                // Bottom: Info Card
                Container(
                  padding: const EdgeInsets.all(DS.lg),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: DS.borderRadiusLg,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (species != null) ...[
                        Text(
                          species!.getCommonName('fr').toUpperCase(),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          species!.scientificName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Pomme de pin inconnue',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: DS.md),
                      
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 16),
                          const SizedBox(width: DS.xs),
                          Expanded(
                            child: Text(
                              '\${cone.latitude.toStringAsFixed(4)}, \${cone.longitude.toStringAsFixed(4)}',
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DS.xs),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                          const SizedBox(width: DS.xs),
                          Text(
                            dateStr,
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
