import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/enum_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/theme/app_color_palettes.dart';
import '../../../core/theme/rarity_colors.dart';
import '../../../core/router/route_names.dart';
import '../../../presentation/providers/collection_provider.dart';
import '../../../data/services/gemini_service.dart';
import '../../../data/models/pine_cone_model.dart';
import '../../../data/models/voice_note_model.dart';
import '../../widgets/voice_note_recorder.dart';
import '../../widgets/voice_note_player.dart';
import '../../widgets/common/strobilus_image.dart';
import '../../widgets/common/full_screen_image_viewer.dart';
import '../../widgets/common/strobilus_snack_bar.dart';
import '../../../presentation/providers/species_provider.dart';

/// Full cone detail page with photo, location, species info, and notes.
class ConeDetailPage extends StatelessWidget {
  final String coneId;

  const ConeDetailPage({super.key, required this.coneId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<StrobilusExtension>()!;
    final collection = context.watch<CollectionProvider>();
    final cone = collection.getConeById(coneId);

    if (cone == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.noResults)),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero photo header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: cone.photoUrls.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        FullScreenImageViewer.show(
                          context,
                          imagePath: cone.photoUrls.first,
                          isNetwork: cone.photoUrls.first.startsWith('http'),
                          heroTag: 'cone_detail_image_${cone.id}',
                        );
                      },
                      child: Hero(
                        tag: 'cone_detail_image_${cone.id}',
                        child: Semantics(
                          label: 'Photo of ${cone.commonName}',
                          image: true,
                          child: StrobilusImage(
                            imagePath: cone.photoUrls.first,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: ext.palette.primary.withValues(alpha: 0.1),
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo_squared.png',
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (action) {
                  if (action == 'edit') {
                    context.pushNamed(
                      RouteNames.editCone,
                      pathParameters: {'coneId': coneId},
                    );
                  } else if (action == 'delete') {
                    _showDeleteDialog(context, collection);
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      l10n.delete,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(DS.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Species names
                if (!cone.isAiIdentified)
                  Container(
                    padding: const EdgeInsets.all(DS.md),
                    decoration: BoxDecoration(
                      color: SemanticColors.warningOchre.withValues(alpha: 0.1),
                      borderRadius: DS.borderRadiusMd,
                      border: Border.all(
                        color: SemanticColors.warningOchre.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.sync,
                              color: SemanticColors.warningOchre,
                            ),
                            const SizedBox(width: DS.sm),
                            Expanded(child: Text(l10n.aiPendingMessage)),
                          ],
                        ),
                        const SizedBox(height: DS.sm),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _identifyWithAI(context, cone, collection),
                            icon: const Icon(Icons.auto_awesome),
                            label: Text(l10n.aiIdentifyButton),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SemanticColors.warningOchre,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(cone.commonName, style: theme.textTheme.headlineMedium),
                if (cone.scientificName != null)
                  Text(
                    cone.scientificName!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: ext.palette.onSurface,
                    ),
                  ),
                const SizedBox(height: DS.md),

                // Rarity + size + condition chips
                Wrap(
                  spacing: DS.sm,
                  runSpacing: DS.sm,
                  children: [
                    _InfoChip(
                      color: RarityColors.forRarity(
                        cone.rarity.name,
                        isDark: theme.brightness == Brightness.dark,
                      ),
                      label: cone.rarity.label(context),
                    ),
                    _InfoChip(
                      color: ext.palette.primary,
                      label: cone.size.label(context),
                    ),
                    _InfoChip(
                      color: ext.palette.secondary,
                      label: cone.condition.label(context),
                    ),
                  ],
                ),
                const SizedBox(height: DS.lg),

                // Location
                _DetailSection(
                  icon: Icons.location_on_outlined,
                  title: l10n.stepLocation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cone.locationName,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        '${cone.city}, ${cone.country}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Divider(height: DS.xl),

                // Date
                _DetailSection(
                  icon: Icons.calendar_today_outlined,
                  title: l10n.collectionSortDate,
                  child: Text(
                    DateFormat.yMMMd(
                      Localizations.localeOf(context).languageCode,
                    ).format(cone.collectedAt),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),

                // Notes
                const Divider(height: DS.xl),
                _DetailSection(
                  icon: Icons.note_alt_outlined,
                  title: l10n.personalNotes,
                  trailing: IconButton(
                    icon: Icon(
                      cone.personalNotes == null || cone.personalNotes!.isEmpty
                          ? Icons.add_circle_outline
                          : Icons.edit_outlined,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    onPressed: () =>
                        _showEditNotesSheet(context, cone, collection),
                  ),
                  child: InkWell(
                    onTap: () => _showEditNotesSheet(context, cone, collection),
                    borderRadius: DS.borderRadiusMd,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: DS.sm,
                        horizontal: DS.xs,
                      ),
                      child:
                          cone.personalNotes != null &&
                              cone.personalNotes!.isNotEmpty
                          ? Text(
                              cone.personalNotes!,
                              style: theme.textTheme.bodyMedium,
                            )
                          : Text(
                              Localizations.localeOf(context).languageCode ==
                                      'fr'
                                  ? 'Ajouter une note écrite...'
                                  : 'Add a written note...',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),
                  ),
                ),

                // Tags
                if (cone.tags.isNotEmpty) ...[
                  const SizedBox(height: DS.md),
                  Wrap(
                    spacing: DS.sm,
                    children: cone.tags.map((tag) {
                      return Chip(label: Text(tag));
                    }).toList(),
                  ),
                ],
                const Divider(height: DS.xxxl),

                // Voice Notes Section
                Text(l10n.voiceNotes, style: theme.textTheme.titleMedium),
                const SizedBox(height: DS.sm),
                ...cone.voiceNoteUrls.map((url) {
                  return VoiceNotePlayer(
                    voiceNote: VoiceNoteModel(
                      id: url, // Using url as ID for now
                      downloadUrl: url.startsWith('http') ? url : '',
                      localPath: url.startsWith('http') ? null : url,
                      durationSeconds: 0, // Will be computed by player
                      recordedAt: DateTime.now(), // Fallback
                    ),
                    onDelete: () async {
                      final updatedUrls = List<String>.from(cone.voiceNoteUrls)
                        ..remove(url);
                      await collection.updateCone(
                        cone.copyWith(voiceNoteUrls: updatedUrls),
                      );
                    },
                  );
                }),
                const SizedBox(height: DS.sm),
                VoiceNoteRecorder(
                  onRecorded: (note) async {
                    if (note.localPath != null) {
                      final updatedUrls = List<String>.from(cone.voiceNoteUrls)
                        ..add(note.localPath!);
                      await collection.updateCone(
                        cone.copyWith(voiceNoteUrls: updatedUrls),
                      );
                    }
                  },
                ),

                const SizedBox(height: DS.xxxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, CollectionProvider collection) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteConeConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              collection.deleteCone(coneId);
              Navigator.pop(ctx);
              context.pop();
              StrobilusSnackBar.success(context, l10n.coneDeletedSuccess);
            },
            child: Text(
              l10n.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _identifyWithAI(
    BuildContext context,
    PineConeModel cone,
    CollectionProvider collection,
  ) async {
    if (cone.photoUrls.isEmpty) return;

    final gemini = context.read<GeminiService>();

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final locale = Localizations.localeOf(context).languageCode;
      final result = await gemini.identifyCone(
        cone.photoUrls.first,
        lat: cone.latitude,
        lon: cone.longitude,
        locationContext: cone.locationName,
        languageCode: locale,
      );

      final topMatch = result.topMatches.isNotEmpty
          ? result.topMatches.first
          : null;
      final chars = result.characteristics;

      ConeSize parsedSize = cone.size;
      if (chars != null) {
        parsedSize = ConeSize.values.firstWhere(
          (e) => e.name.toLowerCase() == chars.estimatedSize.toLowerCase(),
          orElse: () => ConeSize.m,
        );
      }

      String? matchedCommonName;
      if (topMatch != null) {
        final scientificName = topMatch.scientificName.toLowerCase();
        final speciesList = context.read<SpeciesProvider>().allSpecies;
        for (final s in speciesList) {
          final sName = s.scientificName.toLowerCase();
          if (sName == scientificName ||
              sName.contains(scientificName) ||
              scientificName.contains(sName)) {
            matchedCommonName = s.getCommonName(locale);
            break;
          }
        }
      }

      final updatedCone = cone.copyWith(
        isAiIdentified: true,
        commonName:
            matchedCommonName ?? (topMatch?.commonName ?? cone.commonName),
        scientificName: topMatch?.scientificName,
        size: parsedSize,
        aiConfidence: topMatch?.confidencePercent.toDouble(),
      );

      await collection.updateCone(updatedCone);

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        StrobilusSnackBar.success(
          context,
          AppLocalizations.of(context).aiIdentificationComplete,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        StrobilusSnackBar.error(
          context,
          AppLocalizations.of(context).errorGeneric,
        );
      }
    }
  }

  void _showEditNotesSheet(
    BuildContext context,
    PineConeModel cone,
    CollectionProvider collection,
  ) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final controller = TextEditingController(text: cone.personalNotes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: DS.lg,
          right: DS.lg,
          top: DS.lg,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + DS.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.personalNotes.replaceAll(
                    RegExp(
                      r'\s*\(facultatif\)\s*|\s*\(optional\)\s*',
                      caseSensitive: false,
                    ),
                    '',
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: DS.md),
            TextField(
              controller: controller,
              maxLines: 4,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.notesHint,
                border: OutlineInputBorder(borderRadius: DS.borderRadiusMd),
                contentPadding: const EdgeInsets.all(DS.md),
              ),
            ),
            const SizedBox(height: DS.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final updatedCone = cone.copyWith(
                    personalNotes: controller.text.trim(),
                  );
                  await collection.updateCone(updatedCone);
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: DS.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: DS.borderRadiusMd,
                  ),
                ),
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final Color color;
  final String label;

  const _InfoChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DS.md, vertical: DS.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: DS.borderRadiusFull,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Widget? trailing;

  const _DetailSection({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: DS.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(title, style: theme.textTheme.labelLarge),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: DS.xs),
              child,
            ],
          ),
        ),
      ],
    );
  }
}
