import 'package:flutter/material.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/enum_extensions.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/theme/rarity_colors.dart';
import '../../../data/models/pine_cone_model.dart';
import '../../../data/models/species_model.dart';
import '../../../presentation/providers/collection_provider.dart';
import '../../../presentation/providers/species_provider.dart';

/// Pokédex-style species library with discovery tracking, filters, and silhouette mode.
class SpeciesLibraryPage extends StatelessWidget {
  const SpeciesLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final speciesProvider = context.watch<SpeciesProvider>();
    final collectionProvider = context.watch<CollectionProvider>();
    final locale = Localizations.localeOf(context).languageCode;

    // Compute discovered species from user collection
    final collectedSpeciesIds = collectionProvider.allCones
        .where((c) => c.speciesId != null && c.speciesId!.isNotEmpty)
        .map((c) => c.speciesId!)
        .toSet();
    final discoveredCount = speciesProvider.getDiscoveredCount(
      collectedSpeciesIds,
    );
    final totalCount = speciesProvider.allSpecies.length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Premium Pokédex App Bar ──
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.speciesLibrary,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            theme.colorScheme.primary.withValues(alpha: 0.3),
                            theme.colorScheme.surface,
                          ]
                        : [
                            theme.colorScheme.primary.withValues(alpha: 0.15),
                            theme.colorScheme.surface,
                          ],
                  ),
                ),
              ),
            ),
          ),

          // ── Progress bar ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(DS.md, DS.md, DS.md, DS.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.pokedexProgress(discoveredCount, totalCount),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${totalCount > 0 ? (discoveredCount / totalCount * 100).toStringAsFixed(0) : 0}%',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DS.sm),
                  ClipRRect(
                    borderRadius: DS.borderRadiusFull,
                    child: LinearProgressIndicator(
                      value: totalCount > 0 ? discoveredCount / totalCount : 0,
                      minHeight: 8,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Subgenus filter chips ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DS.md,
                vertical: DS.sm,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: l10n.pokedexAllFilter,
                      isSelected: speciesProvider.subgenusFilter == null,
                      onTap: () => speciesProvider.setSubgenusFilter(null),
                    ),
                    const SizedBox(width: DS.sm),
                    _FilterChip(
                      label: l10n.pokedexHardPines,
                      isSelected: speciesProvider.subgenusFilter == 'Pinus',
                      onTap: () => speciesProvider.setSubgenusFilter('Pinus'),
                      iconData: Icons.shield_outlined,
                    ),
                    const SizedBox(width: DS.sm),
                    _FilterChip(
                      label: l10n.pokedexSoftPines,
                      isSelected: speciesProvider.subgenusFilter == 'Strobus',
                      onTap: () => speciesProvider.setSubgenusFilter('Strobus'),
                      iconData: Icons.spa_outlined,
                    ),
                    if (speciesProvider.hasNonPinusSpecies) ...[
                      const SizedBox(width: DS.sm),
                      _FilterChip(
                        label: l10n.pokedexOtherConifers,
                        isSelected: speciesProvider.subgenusFilter == '_other',
                        onTap: () =>
                            speciesProvider.setSubgenusFilter('_other'),
                        iconData: Icons.park_outlined,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // ── Search & Sort Row ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: DS.md),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: TextField(
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: l10n.searchSpecies,
                          prefixIcon: const Icon(Icons.search, size: 20),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: DS.sm,
                          ),
                        ),
                        onChanged: speciesProvider.setSearchQuery,
                      ),
                    ),
                  ),
                  const SizedBox(width: DS.sm),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.sort, size: 22),
                    onSelected: speciesProvider.setSortMode,
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'pokedex',
                        child: Text(l10n.pokedexSortStrobilodex),
                      ),
                      PopupMenuItem(
                        value: 'name',
                        child: Text(l10n.pokedexSortName),
                      ),
                      PopupMenuItem(
                        value: 'rarity',
                        child: Text(l10n.pokedexSortRarity),
                      ),
                      PopupMenuItem(
                        value: 'difficulty',
                        child: Text(l10n.pokedexSortDifficulty),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Count ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(DS.md, DS.sm, DS.md, DS.xs),
              child: Text(
                l10n.speciesTotalCount(speciesProvider.filteredSpecies.length),
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),

          // ── Grid ──
          speciesProvider.isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(DS.md),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: DS.md,
                          crossAxisSpacing: DS.md,
                          childAspectRatio: 0.72,
                        ),
                    delegate: SliverChildBuilderDelegate((_, index) {
                      final species = speciesProvider.filteredSpecies[index];
                      final isDiscovered = collectedSpeciesIds.contains(
                        species.id,
                      );
                      return _PokedexCard(
                        species: species,
                        locale: locale,
                        isDiscovered: isDiscovered,
                      );
                    }, childCount: speciesProvider.filteredSpecies.length),
                  ),
                ),

          // Bottom spacing for FAB
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ── Filter Chip ──

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? iconData;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: DS.md, vertical: DS.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: DS.borderRadiusFull,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconData != null) ...[
              Icon(
                iconData,
                size: 16,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pokédex Species Card ──

class _PokedexCard extends StatelessWidget {
  final SpeciesModel species;
  final String locale;
  final bool isDiscovered;

  const _PokedexCard({
    required this.species,
    required this.locale,
    required this.isDiscovered,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final rarityColor = RarityColors.forRarity(
      species.baseRarity,
      isDark: isDark,
    );

    return GestureDetector(
      onTap: () => context.push('/species/${species.id}'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDiscovered
              ? theme.colorScheme.surfaceContainer
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
          borderRadius: DS.borderRadiusMd,
          border: isDiscovered
              ? Border.all(
                  color: rarityColor.withValues(alpha: 0.4),
                  width: 1.5,
                )
              : null,
          boxShadow: isDiscovered ? DS.shadowCard(theme) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Cone Visual Area ──
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDiscovered
                      ? rarityColor.withValues(alpha: isDark ? 0.15 : 0.08)
                      : theme.colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.3,
                        ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(DS.radiusMd),
                    topRight: Radius.circular(DS.radiusMd),
                  ),
                ),
                child: Stack(
                  children: [
                    // Pokédex number
                    Positioned(
                      top: DS.sm,
                      left: DS.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.8,
                          ),
                          borderRadius: DS.borderRadiusFull,
                        ),
                        child: Text(
                          '#${(species.pokedexNumber ?? 0).toString().padLeft(3, '0')}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                    // Cone icon / silhouette
                    Center(
                      child: isDiscovered
                          ? Text(
                              _getConeEmoji(species),
                              style: const TextStyle(fontSize: 48),
                            )
                          : Icon(
                              Icons.lock_outline,
                              size: 44,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.3),
                            ),
                    ),
                    // Discovery badge
                    if (isDiscovered)
                      Positioned(
                        top: DS.sm,
                        right: DS.sm,
                        child: Icon(
                          Icons.check_circle,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    // Difficulty stars
                    if (species.discoveryDifficulty != null)
                      Positioned(
                        bottom: DS.xs,
                        right: DS.sm,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < species.discoveryDifficulty!
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 10,
                              color: i < species.discoveryDifficulty!
                                  ? (isDark
                                        ? const Color(0xFFFBBF24)
                                        : const Color(0xFFD97706))
                                  : theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // ── Info Section ──
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(DS.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Common name
                    Text(
                      species.getCommonName(locale),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDiscovered
                            ? null
                            : theme.colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Scientific name
                    Text(
                      species.scientificName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: isDiscovered
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.4,
                              ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Rarity badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: rarityColor.withValues(alpha: 0.15),
                        border: Border.all(color: rarityColor),
                        borderRadius: DS.borderRadiusFull,
                      ),
                      child: Text(
                        ConeRarity.values
                            .byName(species.baseRarity)
                            .label(context)
                            .toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: rarityColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Map cone shape/genus to a representative emoji.
  String _getConeEmoji(SpeciesModel s) {
    if (s.genus == 'Araucaria') return '🌿';
    if (s.genus == 'Sequoiadendron') return '🌲';
    if (s.genus == 'Larix') return '🍂';
    if (s.genus == 'Cedrus') return '🌳';
    if (s.genus == 'Abies') return '🎄';
    if (s.genus == 'Picea') return '🎄';
    // Pinus differentiation by size/rarity
    if (s.baseRarity == 'legendary') return '✨';
    if (s.baseRarity == 'veryRare') return '💎';
    if (s.baseRarity == 'rare') return '⭐';
    if ((s.coneLengthMaxCm ?? 10) >= 20) return '🌲';
    return '🌰';
  }
}
