
import 'package:flutter/material.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../../../core/extensions/enum_extensions.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/theme/app_color_palettes.dart';
import '../../../core/theme/rarity_colors.dart';
import '../../../core/router/route_names.dart';
import '../../../data/models/pine_cone_model.dart';
import '../../../presentation/providers/collection_provider.dart';
import '../../widgets/common/strobilus_image.dart';

/// Grid/list collection view with search, sort, and filter.
class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  bool _isGridView = true;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final collection = context.watch<CollectionProvider>();
    final cones = collection.filteredCones;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navCollection),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
            tooltip: _isGridView
                ? l10n.collectionListView
                : l10n.collectionGridView,
          ),
          PopupMenuButton<CollectionSort>(
            icon: const Icon(Icons.sort),
            onSelected: collection.setSort,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: CollectionSort.newestFirst,
                child: Text(l10n.collectionSortDate),
              ),
              PopupMenuItem(
                value: CollectionSort.species,
                child: Text(l10n.collectionSortSpecies),
              ),
              PopupMenuItem(
                value: CollectionSort.rarity,
                child: Text(l10n.collectionSortRarity),
              ),
              PopupMenuItem(
                value: CollectionSort.country,
                child: Text(l10n.collectionSortCountry),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DS.md,
              vertical: DS.sm,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.collectionSearch,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          collection.setFilter(const CollectionFilter());
                        },
                      )
                    : null,
              ),
              onChanged: (query) {
                collection.setFilter(
                  collection.filter.copyWith(searchQuery: query),
                );
              },
            ),
          ),

          // Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DS.md),
            child: Row(
              children: [
                Text(
                  l10n.collectionTotal(cones.length),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: DS.sm),

          // Content
          Expanded(
            child: cones.isEmpty
                ? _EmptyState(l10n: l10n)
                : _isGridView
                ? _GridView(cones: cones)
                : _ListView(cones: cones),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.scale(
            scale: 2.0,
            child: Image.asset('assets/images/logo_squared.png', width: 96, height: 96),
          ),
          const SizedBox(height: DS.md),
          Text(
            l10n.collectionEmpty,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: DS.sm),
          Text(
            l10n.collectionEmptySubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final List<PineConeModel> cones;

  const _GridView({required this.cones});

  @override
  Widget build(BuildContext context) {
    // For a moodboard feel, we give some extra padding and adjust aspect ratio
    return GridView.builder(
      padding: const EdgeInsets.all(DS.xl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: DS.xxl,
        crossAxisSpacing: DS.xl,
        childAspectRatio: 0.75, // Taller for polaroid style
      ),
      itemCount: cones.length,
      itemBuilder: (context, index) => _ConeCard(cone: cones[index], index: index),
    );
  }
}


class _ListView extends StatelessWidget {
  final List<PineConeModel> cones;

  const _ListView({required this.cones});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(DS.md),
      itemCount: cones.length,
      separatorBuilder: (_, __) => const SizedBox(height: DS.sm),
      itemBuilder: (context, index) => _ConeListTile(cone: cones[index]),
    );
  }
}

class _ConeCard extends StatelessWidget {
  final PineConeModel cone;
  final int index;

  const _ConeCard({required this.cone, required this.index});

  @override
  Widget build(BuildContext context) {
    // Deterministic pseudo-randomness based on index for the moodboard slant
    final random = math.Random(index * 100);
    // Slant between -4 and 4 degrees
    final double slantDegrees = (random.nextDouble() * 8) - 4;
    final double slantRadians = slantDegrees * math.pi / 180;
    
    // Tape colors
    final tapeColors = [
      const Color(0xFFFDE68A), // Amber-100
      const Color(0xFFA7F3D0), // Emerald-100
      const Color(0xFFFECACA), // Red-100
      const Color(0xFFBFDBFE), // Blue-100
      const Color(0xFFE9D5FF), // Purple-100
      const Color(0xFFFED7AA), // Orange-100
    ];
    final tapeColor = tapeColors[random.nextInt(tapeColors.length)];

    return Transform.rotate(
      angle: slantRadians,
      child: GestureDetector(
        onTap: () => context.push('/cone/${cone.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFDFBF7), // Warm off-white paper color
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(2, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Photo Area (Square)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                        ),
                        child: ClipRect(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Semantics(
                                label: 'Photo of ${cone.commonName}',
                                image: true,
                                child: StrobilusImage(
                                  imagePath: cone.photoUrls.isNotEmpty ? cone.photoUrls.first : null,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Popup menu
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_horiz, size: 14, color: Colors.white),
                                    padding: EdgeInsets.zero,
                                    onSelected: (action) {
                                      if (action == 'edit') {
                                        context.pushNamed(
                                          RouteNames.editCone,
                                          pathParameters: {'coneId': cone.id},
                                        );
                                      } else if (action == 'delete') {
                                        context.read<CollectionProvider>().deleteCone(cone.id);
                                      }
                                    },
                                    itemBuilder: (_) => [
                                      PopupMenuItem(value: 'edit', child: Text(AppLocalizations.of(context).edit)),
                                      PopupMenuItem(value: 'delete', child: Text(AppLocalizations.of(context).delete)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Text Area (Bottom)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cone.commonName,
                          style: GoogleFonts.kalam(
                            textStyle: const TextStyle(
                              color: Color(0xFF1E293B), // Dark slate
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Small tag for rarity/details
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black.withValues(alpha: 0.15)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: RarityColors.forRarity(cone.rarity.name, isDark: false),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                cone.rarity.label(context).toUpperCase(),
                                style: GoogleFonts.kalam(
                                  textStyle: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF475569),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Tape at the top center
              Positioned(
                top: -8,
                left: 0,
                right: 0,
                child: Center(
                  child: Transform.rotate(
                    angle: (random.nextDouble() * 10 - 5) * math.pi / 180,
                    child: Container(
                      width: 40,
                      height: 14,
                      decoration: BoxDecoration(
                        color: tapeColor.withValues(alpha: 0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConeListTile extends StatelessWidget {
  final PineConeModel cone;

  const _ConeListTile({required this.cone});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        onTap: () => context.push('/cone/${cone.id}'),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: DS.borderRadiusMd,
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          ),
          child: ClipRRect(
            borderRadius: DS.borderRadiusMd,
            child: StrobilusImage(
              imagePath: cone.photoUrls.isNotEmpty
                  ? cone.photoUrls.first
                  : null,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                cone.commonName,
                style: theme.textTheme.titleSmall,
                maxLines: 1,
              ),
            ),
            if (!cone.isAiIdentified)
              const Padding(
                padding: EdgeInsets.only(left: DS.xs),
                child: Icon(
                  Icons.sync,
                  size: 16,
                  color: SemanticColors.warningOchre,
                ),
              ),
          ],
        ),
        subtitle: Text(
          '${cone.city}, ${cone.country}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DS.sm,
                vertical: DS.xs,
              ),
              decoration: BoxDecoration(
                color: RarityColors.forRarity(
                  cone.rarity.name,
                  isDark: theme.brightness == Brightness.dark,
                ).withValues(alpha: 0.15),
                border: Border.all(
                  color: RarityColors.forRarity(
                    cone.rarity.name,
                    isDark: theme.brightness == Brightness.dark,
                  ),
                ),
                borderRadius: DS.borderRadiusFull,
              ),
              child: Text(
                cone.rarity.label(context).toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: RarityColors.forRarity(
                    cone.rarity.name,
                    isDark: theme.brightness == Brightness.dark,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 20),
              onSelected: (action) {
                if (action == 'edit') {
                  context.pushNamed(
                    RouteNames.editCone,
                    pathParameters: {'coneId': cone.id},
                  );
                } else if (action == 'delete') {
                  context.read<CollectionProvider>().deleteCone(cone.id);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Text(AppLocalizations.of(context).edit),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(AppLocalizations.of(context).delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
