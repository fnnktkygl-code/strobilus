import 'package:flutter/material.dart';
import 'strobilus_image.dart';

/// A full-screen interactive image viewer supporting pinch-to-zoom and panning.
class FullScreenImageViewer extends StatelessWidget {
  final String imagePath;
  final bool isNetwork;
  final String? heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imagePath,
    required this.isNetwork,
    this.heroTag,
  });

  /// Helper to push this viewer onto the navigation stack.
  static Future<void> show(
    BuildContext context, {
    required String imagePath,
    required bool isNetwork,
    String? heroTag,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          imagePath: imagePath,
          isNetwork: isNetwork,
          heroTag: heroTag,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = StrobilusImage(
      imagePath: imagePath,
      fit: BoxFit.contain,
      placeholder: const Center(
        child: Icon(Icons.broken_image, color: Colors.white54, size: 64),
      ),
    );

    if (heroTag != null) {
      imageWidget = Hero(tag: heroTag!, child: imageWidget);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            clipBehavior: Clip.none,
            minScale: 0.8,
            maxScale: 5.0,
            child: imageWidget,
          ),
        ),
      ),
    );
  }
}
