
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/extensions/enum_extensions.dart';
import '../../../core/theme/app_color_palettes.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/theme/rarity_colors.dart';
import '../../../data/models/pine_cone_model.dart';
import '../../../data/models/species_model.dart';
import '../../../data/services/firebase/firestore_service.dart';
import '../../../data/services/firebase/storage_service.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/collection_provider.dart';
import '../../../presentation/providers/map_provider.dart';
import '../../../presentation/providers/species_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/strobilus_image.dart';

/// Premium species detail page with taxonomy, morphology, distribution, and collection tracking.
class SpeciesDetailPage extends StatelessWidget {
  final String speciesId;

  const SpeciesDetailPage({super.key, required this.speciesId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;
    final speciesProvider = context.watch<SpeciesProvider>();
    final collectionProvider = context.watch<CollectionProvider>();
    final species = speciesProvider.getSpeciesById(speciesId);

    if (species == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.noResults)),
      );
    }

    final userCones = collectionProvider.getConesBySpecies(speciesId);
    final rarityColor = RarityColors.forRarity(
      species.baseRarity,
      isDark: isDark,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          _SpeciesInteractiveHeader(
            species: species,
            rarityColor: rarityColor,
            isDark: isDark,
            locale: locale,
          ),

          SliverPadding(
            padding: const EdgeInsets.all(DS.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Scientific Name & Rarity ──
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        species.scientificName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DS.md,
                        vertical: DS.sm,
                      ),
                      decoration: BoxDecoration(
                        color: rarityColor.withValues(alpha: 0.15),
                        borderRadius: DS.borderRadiusFull,
                        border: Border.all(color: rarityColor),
                      ),
                      child: Text(
                        ConeRarity.values
                            .byName(species.baseRarity)
                            .label(context)
                            .toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: rarityColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Discovery Difficulty ──
                if (species.discoveryDifficulty != null) ...[
                  const SizedBox(height: DS.md),
                  Row(
                    children: [
                      Text(
                        l10n.discoveryDifficultyTitle,
                        style: theme.textTheme.labelMedium,
                      ),
                      const SizedBox(width: DS.sm),
                      ...List.generate(
                        5,
                        (i) => Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(
                            i < species.discoveryDifficulty!
                                ? Icons.star
                                : Icons.star_border,
                            size: 16,
                            color: i < species.discoveryDifficulty!
                                ? (isDark
                                      ? const Color(0xFFFBBF24)
                                      : const Color(0xFFD97706))
                                : theme.colorScheme.onSurfaceVariant.withValues(
                                    alpha: 0.3,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: DS.lg),

                // ── Description ──
                Text(
                  l10n.speciesDescription,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: DS.sm),
                Text(
                  species.getDescription(locale),
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: DS.xl),

                // ── Taxonomy Section ──
                if (species.genus == 'Pinus' && species.subgenus != null) ...[
                  _SectionHeader(
                    icon: Icons.account_tree_outlined,
                    title: l10n.taxonomyTitle,
                  ),
                  const SizedBox(height: DS.sm),
                  _TaxonomyTree(species: species, l10n: l10n),
                  const SizedBox(height: DS.xl),
                ],

                // ── Basic Info ──
                _SectionHeader(
                  icon: Icons.info_outline,
                  title: l10n.speciesDescription,
                ),
                const SizedBox(height: DS.sm),
                _InfoRow(label: l10n.speciesFamily, value: species.family),
                _InfoRow(label: l10n.speciesGenus, value: species.genus),
                _InfoRow(
                  label: l10n.speciesSizeRange,
                  value: species.getSizeRange(locale),
                ),
                _InfoRow(
                  label: l10n.speciesHabitat,
                  value: species.getHabitat(locale),
                ),
                const SizedBox(height: DS.xl),

                // ── Cone Morphology ──
                if (species.genus == 'Pinus' || species.coneShape != null) ...[
                  _SectionHeader(
                    icon: Icons.eco_outlined,
                    title: l10n.morphologyTitle,
                  ),
                  const SizedBox(height: DS.sm),
                  _MorphologyGrid(species: species, l10n: l10n),
                  const SizedBox(height: DS.xl),
                ],

                // ── Distribution ──
                _SectionHeader(
                  icon: Icons.public,
                  title: l10n.distributionTitle,
                ),
                const SizedBox(height: DS.sm),
                _InfoRow(
                  label: l10n.distributionNative,
                  value: species.continents.join(', '),
                ),
                const SizedBox(height: DS.sm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<MapProvider>().setViewMode(MapViewMode.distribution, speciesId: species.id);
                      context.go('/map');
                    },
                    icon: const Icon(Icons.map_outlined),
                    label: Text(AppLocalizations.of(context).viewInteractiveMap),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SemanticColors.successLeaf,
                      side: const BorderSide(color: SemanticColors.successLeaf),
                      padding: const EdgeInsets.symmetric(vertical: DS.md),
                    ),
                  ),
                ),
                if (species.isIntroducedOrnamental == true)
                  Padding(
                    padding: const EdgeInsets.only(top: DS.xs),
                    child: Row(
                      children: [
                        Icon(
                          Icons.park,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: DS.sm),
                        Expanded(
                          child: Text(
                            l10n.distributionIntroduced,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: DS.xl),

                // ── Conservation ──
                if (species.conservationStatus != null) ...[
                  _SectionHeader(
                    icon: Icons.shield_outlined,
                    title: l10n.conservationTitle,
                  ),
                  const SizedBox(height: DS.sm),
                  _ConservationBadge(
                    status: species.conservationStatus!,
                    l10n: l10n,
                  ),
                  const SizedBox(height: DS.xl),
                ],

                // ── Interesting Facts ──
                if (species.getInterestingFacts(locale).isNotEmpty) ...[
                  _SectionHeader(
                    icon: Icons.lightbulb_outline,
                    title: l10n.speciesInterestingFacts,
                  ),
                  const SizedBox(height: DS.sm),
                  ...species
                      .getInterestingFacts(locale)
                      .map(
                        (fact) => Padding(
                          padding: const EdgeInsets.only(bottom: DS.sm),
                          child: Container(
                            padding: const EdgeInsets.all(DS.md),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              borderRadius: DS.borderRadiusMd,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '💡 ',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: DS.sm),
                                Expanded(
                                  child: Text(
                                    fact,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  const SizedBox(height: DS.lg),
                ],

                // ── User Specimens ──
                _SectionHeader(
                  icon: Icons.collections_outlined,
                  title: l10n.speciesYourSpecimens,
                ),
                const SizedBox(height: DS.sm),
                if (userCones.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(DS.lg),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: DS.borderRadiusMd,
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 32,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: DS.sm),
                          Text(
                            l10n.speciesNotInCollection,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  Container(
                    padding: const EdgeInsets.all(DS.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: DS.borderRadiusMd,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: DS.md),
                        Text(
                          '${userCones.length} ${l10n.speciesInCollection}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DS.md),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: userCones.length,
                      separatorBuilder: (_, __) => const SizedBox(width: DS.md),
                      itemBuilder: (context, index) {
                        return _SpecimenCard(cone: userCones[index]);
                      },
                    ),
                  ),
                ],
                const SizedBox(height: DS.xxxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ──

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: DS.sm),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Info Row ──

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DS.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

// ── Taxonomy Tree ──

class _TaxonomyTree extends StatelessWidget {
  final dynamic species;
  final AppLocalizations l10n;

  const _TaxonomyTree({required this.species, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DS.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: DS.borderRadiusMd,
      ),
      child: Column(
        children: [
          if (species.subgenus != null)
            _TaxonomyLevel(
              label: l10n.taxonomySubgenus,
              value: species.subgenus!,
              subtitle: species.subgenus == 'Strobus'
                  ? 'Haploxylon (Soft Pines)'
                  : 'Diploxylon (Hard Pines)',
              depth: 0,
              theme: theme,
            ),
          if (species.section != null)
            _TaxonomyLevel(
              label: l10n.taxonomySection,
              value: species.section!,
              depth: 1,
              theme: theme,
            ),
          if (species.subsection != null)
            _TaxonomyLevel(
              label: l10n.taxonomySubsection,
              value: species.subsection!,
              depth: 2,
              theme: theme,
            ),
          _TaxonomyLevel(
            label: '',
            value: species.scientificName,
            depth: 3,
            theme: theme,
            isSpecies: true,
          ),
        ],
      ),
    );
  }
}

class _TaxonomyLevel extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final int depth;
  final ThemeData theme;
  final bool isSpecies;

  const _TaxonomyLevel({
    required this.label,
    required this.value,
    this.subtitle,
    required this.depth,
    required this.theme,
    this.isSpecies = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: depth * 20.0, bottom: DS.sm),
      child: Row(
        children: [
          if (depth > 0)
            Padding(
              padding: const EdgeInsets.only(right: DS.sm),
              child: Icon(
                Icons.subdirectory_arrow_right,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
              ),
            ),
          if (label.isNotEmpty) ...[
            Text(
              '$label: ',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: isSpecies
                      ? theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        )
                      : theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

// ── Morphology Grid ──

class _MorphologyGrid extends StatelessWidget {
  final dynamic species;
  final AppLocalizations l10n;

  const _MorphologyGrid({required this.species, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <_MorphItem>[];

    // Cone size
    if (species.coneLengthMinCm != null && species.coneLengthMaxCm != null) {
      items.add(
        _MorphItem(
          icon: Icons.straighten,
          label: l10n.morphologyConeSize,
          value:
              '${species.coneLengthMinCm!.toStringAsFixed(0)}–${species.coneLengthMaxCm!.toStringAsFixed(0)} cm',
        ),
      );
    }

    // Cone weight
    if (species.coneWeightMaxKg != null) {
      items.add(
        _MorphItem(
          icon: Icons.fitness_center,
          label: l10n.morphologyConeWeight,
          value: '${species.coneWeightMaxKg} kg',
        ),
      );
    }

    // Shape
    if (species.coneShape != null) {
      items.add(
        _MorphItem(
          icon: Icons.category_outlined,
          label: l10n.morphologyConeShape,
          value: species.coneShape!.replaceFirst(
            species.coneShape![0],
            species.coneShape![0].toUpperCase(),
          ),
        ),
      );
    }

    // Umbo
    if (species.umboPosition != null) {
      items.add(
        _MorphItem(
          icon: Icons.adjust,
          label: l10n.morphologyUmbo,
          value: species.umboPosition == 'dorsal'
              ? l10n.morphologyUmboDorsal
              : l10n.morphologyUmboTerminal,
        ),
      );
    }

    // Mucro
    if (species.hasMucro != null) {
      items.add(
        _MorphItem(
          icon: species.hasMucro!
              ? Icons.push_pin
              : Icons.remove_circle_outline,
          label: l10n.morphologyMucro,
          value: species.hasMucro!
              ? l10n.morphologyMucroPresent
              : l10n.morphologyMucroAbsent,
        ),
      );
    }

    // Apophysis
    if (species.apophysisShape != null) {
      items.add(
        _MorphItem(
          icon: Icons.hexagon_outlined,
          label: l10n.morphologyApophysis,
          value: species.apophysisShape!.replaceFirst(
            species.apophysisShape![0],
            species.apophysisShape![0].toUpperCase(),
          ),
        ),
      );
    }

    // Serotiny
    if (species.isSerotinous != null) {
      items.add(
        _MorphItem(
          icon: species.isSerotinous!
              ? Icons.local_fire_department
              : Icons.lock_open,
          label: l10n.morphologySerotiny,
          value: species.isSerotinous!
              ? l10n.morphologySerotinous
              : l10n.morphologyNonSerotinous,
          highlight: species.isSerotinous!,
        ),
      );
    }

    // Needles
    if (species.needlesPerFascicle != null) {
      items.add(
        _MorphItem(
          icon: Icons.grass,
          label: l10n.morphologyNeedles,
          value: '${species.needlesPerFascicle}',
        ),
      );
    }

    // Seed type
    if (species.seedType != null) {
      String seedLabel;
      switch (species.seedType) {
        case 'winged':
          seedLabel = l10n.morphologySeedWinged;
          break;
        case 'wingless':
          seedLabel = l10n.morphologySeedWingless;
          break;
        case 'edible_nut':
          seedLabel = l10n.morphologySeedEdible;
          break;
        case 'bird_dispersed':
          seedLabel = l10n.morphologySeedBird;
          break;
        default:
          seedLabel = species.seedType!;
      }
      items.add(
        _MorphItem(
          icon: Icons.energy_savings_leaf,
          label: l10n.morphologySeedType,
          value: seedLabel,
        ),
      );
    }

    return Wrap(
      spacing: DS.sm,
      runSpacing: DS.sm,
      children: items
          .map((item) => _MorphChip(item: item, theme: theme))
          .toList(),
    );
  }
}

class _MorphItem {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _MorphItem({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });
}

class _MorphChip extends StatelessWidget {
  final _MorphItem item;
  final ThemeData theme;

  const _MorphChip({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DS.md, vertical: DS.sm),
      decoration: BoxDecoration(
        color: item.highlight
            ? const Color(0xFFFF6B35).withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: DS.borderRadiusSm,
        border: item.highlight
            ? Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.4))
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 18,
            color: item.highlight
                ? const Color(0xFFFF6B35)
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Conservation Badge ──

class _ConservationBadge extends StatelessWidget {
  final String status;
  final AppLocalizations l10n;

  const _ConservationBadge({required this.status, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color badgeColor;
    String label;

    switch (status) {
      case 'LC':
        badgeColor = const Color(0xFF16A34A);
        label = l10n.conservationLC;
        break;
      case 'NT':
        badgeColor = const Color(0xFFCA8A04);
        label = l10n.conservationNT;
        break;
      case 'VU':
        badgeColor = const Color(0xFFEA580C);
        label = l10n.conservationVU;
        break;
      case 'EN':
        badgeColor = const Color(0xFFDC2626);
        label = l10n.conservationEN;
        break;
      case 'CR':
        badgeColor = const Color(0xFF991B1B);
        label = l10n.conservationCR;
        break;
      default:
        badgeColor = const Color(0xFF6B7280);
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DS.md, vertical: DS.sm),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: DS.borderRadiusSm,
        border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: DS.borderRadiusFull,
            ),
            child: Center(
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: DS.sm),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeciesInteractiveHeader extends StatefulWidget {
  final SpeciesModel species;
  final Color rarityColor;
  final bool isDark;
  final String locale;

  const _SpeciesInteractiveHeader({
    required this.species,
    required this.rarityColor,
    required this.isDark,
    required this.locale,
  });

  @override
  State<_SpeciesInteractiveHeader> createState() =>
      _SpeciesInteractiveHeaderState();
}

class _SpeciesInteractiveHeaderState extends State<_SpeciesInteractiveHeader> {
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final auth = context.read<AuthProvider>();
    final firestore = context.read<FirestoreService>();
    final storage = context.read<StorageService>();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(DS.radiusLg)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: DS.md),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.4,
                  ),
                  borderRadius: DS.borderRadiusFull,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: theme.colorScheme.onSurface,
              ),
              title: Text(l10n.takePhoto),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo, color: theme.colorScheme.onSurface),
              title: Text(l10n.chooseFromGallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            const SizedBox(height: DS.md),
          ],
        ),
      ),
    );

    if (source == null) return;

    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
    );

    if (pickedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final bytes = await pickedFile.readAsBytes();
      final url = await storage.uploadSpeciesIllustration(
        speciesId: widget.species.id,
        imageBytes: bytes,
      );

      await auth.updateSpeciesPhoto(
        speciesId: widget.species.id,
        photoUrl: url,
        firestoreService: firestore,
      );
      
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.editProfileSaveSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorGeneric),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final customPhotoUrl =
        auth.userModel?.customSpeciesPhotos[widget.species.id];

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.species.getCommonName(widget.locale),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        background: GestureDetector(
          onTap: () => _pickAndUploadImage(context),
          child: Container(
            decoration: BoxDecoration(
              gradient: customPhotoUrl == null
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.rarityColor.withValues(
                          alpha: widget.isDark ? 0.3 : 0.15,
                        ),
                        theme.colorScheme.surface,
                      ],
                    )
                  : null,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (customPhotoUrl != null)
                  Image.network(
                    customPhotoUrl,
                    fit: BoxFit.cover,
                  )
                else
                  Center(
                    child: Text(
                      '#${(widget.species.pokedexNumber ?? 0).toString().padLeft(3, '0')}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.15,
                        ),
                        fontFamily: 'monospace',
                        fontSize: 40,
                      ),
                    ),
                  ),
                
                // Dark overlay if image is present to make title readable
                if (customPhotoUrl != null)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.colorScheme.surface,
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),

                // Uploading indicator or Add photo hint
                if (_isUploading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                else
                  Positioned(
                    bottom: DS.md,
                    right: DS.md,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        customPhotoUrl == null ? Icons.add_a_photo : Icons.edit,
                        size: 20,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Specimen Card ──

class _SpecimenCard extends StatelessWidget {
  final PineConeModel cone;

  const _SpecimenCard({required this.cone});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<StrobilusExtension>()!;

    return GestureDetector(
      onTap: () => context.push('/cone/${cone.id}'),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: DS.borderRadiusMd,
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  cone.photoUrls.isNotEmpty
                      ? StrobilusImage(
                          imagePath: cone.photoUrls.first,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.forest,
                            size: 40,
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                        ),
                  if (cone.isAiIdentified)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ext.palette.primary,
                          borderRadius: DS.borderRadiusFull,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            const Text(
                              'AI',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cone.city.isNotEmpty ? cone.city : cone.locationName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${cone.collectedAt.day}/${cone.collectedAt.month}/${cone.collectedAt.year}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
