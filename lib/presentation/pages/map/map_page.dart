import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:strobilus/l10n/app_localizations.dart';

import '../../../core/theme/app_color_palettes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/theme/rarity_colors.dart';
import '../../../data/models/pine_cone_model.dart';
import '../../../data/models/species_model.dart';
import '../../../data/services/geojson_parser.dart';
import '../../../presentation/providers/collection_provider.dart';
import '../../../presentation/providers/map_provider.dart';
import '../../../presentation/providers/species_provider.dart';
import '../../widgets/common/strobilus_image.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  Map<String, List<List<LatLng>>> _countryPolygons = {};
  bool _isLoadingGeoJson = true;
  bool _hasCenteredOnUser = false;

  @override
  void initState() {
    super.initState();
    _loadGeoJson();
    _determinePosition();
  }

  Future<void> _loadGeoJson() async {
    final polygons = await GeoJsonParser.loadCountryPolygons();
    if (mounted) {
      setState(() {
        _countryPolygons = polygons;
        _isLoadingGeoJson = false;
      });
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    if (mounted && !_hasCenteredOnUser) {
      _hasCenteredOnUser = true;
      _mapController.move(LatLng(position.latitude, position.longitude), 4.0);
      context.read<MapProvider>().setCenter(LatLng(position.latitude, position.longitude));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<StrobilusExtension>()!;
    final mapProvider = context.watch<MapProvider>();
    final collectionProvider = context.watch<CollectionProvider>();
    final speciesProvider = context.watch<SpeciesProvider>();
    final isDark = theme.brightness == Brightness.dark;

    final cones = mapProvider.filterCones(collectionProvider.allCones);

    final List<Polygon> polygons = [];
    final List<CircleMarker> circles = [];

    if (mapProvider.viewMode == MapViewMode.distribution && mapProvider.selectedSpeciesDistributionId != null) {
      final species = speciesProvider.getSpeciesById(mapProvider.selectedSpeciesDistributionId!);
      if (species != null) {
        final nativeCodes = species.nativeCountryCodes;
        final introducedCodes = species.introducedCountryCodes ?? [];

        for (var entry in _countryPolygons.entries) {
          final isNative = nativeCodes.contains(entry.key);
          final isIntroduced = introducedCodes.contains(entry.key);

          if (isNative || isIntroduced) {
            final color = isNative 
              ? SemanticColors.successLeaf.withValues(alpha: 0.5) 
              : Colors.amber.withValues(alpha: 0.5);
            final borderColor = isNative 
              ? SemanticColors.successLeaf 
              : Colors.amber;

            for (var points in entry.value) {
              polygons.add(Polygon(
                points: points,
                color: color,
                borderColor: borderColor,
                borderStrokeWidth: 1.5,
              ));
            }
          }
        }

        // Add circles for user's findings of this species
        final userCones = collectionProvider.allCones
            .where((c) => c.speciesId == species.id);
        for (var cone in userCones) {
          circles.add(CircleMarker(
            point: LatLng(cone.latitude, cone.longitude),
            color: ext.palette.primary.withValues(alpha: 0.3),
            borderColor: ext.palette.primary.withValues(alpha: 0.8),
            borderStrokeWidth: 2,
            radius: 15000, // 15 km radius to roughly cover a city area
            useRadiusInMeter: true,
          ));
        }
      }
    } else if (mapProvider.viewMode == MapViewMode.collection) {
      // Add circles for all user's findings (normal mode)
      for (var cone in collectionProvider.allCones) {
        circles.add(CircleMarker(
          point: LatLng(cone.latitude, cone.longitude),
          color: ext.palette.primary.withValues(alpha: 0.2),
          borderColor: ext.palette.primary.withValues(alpha: 0.5),
          borderStrokeWidth: 1.5,
          radius: 15000,
          useRadiusInMeter: true,
        ));
      }
    }

    // CartoDB Dark Matter for premium look in dark mode
    final tileUrl = isDark 
      ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
      : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';

    return Scaffold(
      body: Stack(
        children: [
          // Background Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: mapProvider.center,
              initialZoom: mapProvider.zoom,
              minZoom: 3.0,
              maxZoom: 18.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  mapProvider.setCenter(position.center);
                  mapProvider.setZoom(position.zoom);
                }
              },
              onTap: (_, __) => mapProvider.selectCone(null),
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                userAgentPackageName: 'com.strobilus.strobilus',
                subdomains: const ['a', 'b', 'c'],
              ),
              if (polygons.isNotEmpty)
                PolygonLayer(polygons: polygons),
              if (circles.isNotEmpty)
                CircleLayer(circles: circles),
              if (mapProvider.viewMode == MapViewMode.collection)
                MarkerLayer(
                  markers: cones.map((cone) => _buildMarker(cone, ext, context)).toList(),
                ),
            ],
          ),

          // Top Gradient overlay for UI readability
          Positioned(
            top: 0, left: 0, right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Header
          Positioned(
            top: MediaQuery.of(context).padding.top + DS.sm,
            left: DS.md,
            right: DS.md,
            child: Row(
              children: [
                _GlassToggle(
                  isActive: mapProvider.viewMode == MapViewMode.collection,
                  label: AppLocalizations.of(context).navCollection,
                  icon: Icons.pin_drop,
                  onTap: () => mapProvider.setViewMode(MapViewMode.collection),
                ),
                const SizedBox(width: DS.sm),
                _GlassToggle(
                  isActive: mapProvider.viewMode == MapViewMode.distribution,
                  label: 'Distribution',
                  icon: Icons.public,
                  onTap: () {
                    if (mapProvider.selectedSpeciesDistributionId == null && speciesProvider.allSpecies.isNotEmpty) {
                      mapProvider.setViewMode(MapViewMode.distribution, speciesId: speciesProvider.allSpecies.first.id);
                    } else {
                      mapProvider.setViewMode(MapViewMode.distribution);
                    }
                  },
                ),
              ],
            ),
          ),

          // Map Controls (Right side)
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: DS.md,
            child: Column(
              children: [
                _GlassButton(
                  icon: Icons.my_location,
                  onTap: () async {
                    final position = await Geolocator.getCurrentPosition();
                    _mapController.move(LatLng(position.latitude, position.longitude), _mapController.camera.zoom);
                  },
                ),
                if (mapProvider.viewMode == MapViewMode.collection) ...[
                  const SizedBox(height: DS.sm),
                  _GlassButton(
                    icon: Icons.filter_list,
                    onTap: () => _showFilterSheet(context),
                    badge: mapProvider.hasFilters,
                  ),
                ],
              ],
            ),
          ),

          // Empty State Overlay
          if (mapProvider.viewMode == MapViewMode.collection && cones.isEmpty)
            Positioned(
              bottom: 120 + MediaQuery.of(context).padding.bottom,
              left: DS.xl,
              right: DS.xl,
              child: Container(
                padding: const EdgeInsets.all(DS.xl),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: DS.borderRadiusLg,
                  boxShadow: DS.shadowElevated(theme),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(DS.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.explore,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: DS.md),
                    Text(
                      AppLocalizations.of(context).emptyMapTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DS.sm),
                    Text(
                      AppLocalizations.of(context).emptyMapSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DS.lg),
                    FilledButton.icon(
                      onPressed: () => context.push('/add-cone'),
                      icon: const Icon(Icons.add),
                      label: Text(AppLocalizations.of(context).emptyCollectionCta),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Info Card (Cone or Species)
          Positioned(
            left: DS.md,
            right: DS.md,
            bottom: DS.lg + MediaQuery.of(context).padding.bottom,
            child: mapProvider.viewMode == MapViewMode.collection
                ? (mapProvider.selectedConeId != null
                    ? _ConeInfoCard(cone: collectionProvider.getConeById(mapProvider.selectedConeId!))
                    : const SizedBox.shrink())
                : (mapProvider.selectedSpeciesDistributionId != null
                    ? _SpeciesDistributionCard(
                        species: speciesProvider.getSpeciesById(mapProvider.selectedSpeciesDistributionId!),
                        polygonsLoaded: !_isLoadingGeoJson,
                      )
                    : const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }

  Marker _buildMarker(PineConeModel cone, StrobilusExtension ext, BuildContext context) {
    return Marker(
      point: LatLng(cone.latitude, cone.longitude),
      width: 44,
      height: 44,
      child: GestureDetector(
        onTap: () => context.read<MapProvider>().selectCone(cone.id),
        child: Container(
          decoration: BoxDecoration(
            color: ext.palette.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: RarityColors.forRarity(
                cone.rarity.name,
                isDark: Theme.of(context).brightness == Brightness.dark,
              ),
              width: 3,
            ),
            boxShadow: DS.shadowCard(Theme.of(context)),
          ),
          child: Center(
            child: Image.asset('assets/images/logo_squared.png', width: 24, height: 24),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(DS.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: DS.lg),
            Text(AppLocalizations.of(ctx).mapFilterComingSoon, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: DS.xxl),
          ],
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool badge;

  const _GlassButton({required this.icon, required this.onTap, this.badge = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withValues(alpha: 0.1),
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  if (badge)
                    Positioned(
                      top: 10, right: 10,
                      child: Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(color: SemanticColors.successLeaf, shape: BoxShape.circle),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassToggle extends StatelessWidget {
  final bool isActive;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GlassToggle({required this.isActive, required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: isActive ? SemanticColors.successLeaf.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.1),
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: DS.md),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withValues(alpha: isActive ? 0.4 : 0.1)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: DS.xs),
                    Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeciesDistributionCard extends StatelessWidget {
  final SpeciesModel? species;
  final bool polygonsLoaded;

  const _SpeciesDistributionCard({this.species, required this.polygonsLoaded});

  @override
  Widget build(BuildContext context) {
    if (species == null) return const SizedBox.shrink();

    final speciesProvider = context.read<SpeciesProvider>();
    final mapProvider = context.read<MapProvider>();
    final ext = Theme.of(context).extension<StrobilusExtension>()!;
    final allSpecies = speciesProvider.allSpecies;
    final currentIndex = allSpecies.indexWhere((s) => s.id == species!.id);
    
    void goToPrevious() {
      if (currentIndex > 0) {
        mapProvider.setViewMode(MapViewMode.distribution, speciesId: allSpecies[currentIndex - 1].id);
      } else {
        mapProvider.setViewMode(MapViewMode.distribution, speciesId: allSpecies.last.id);
      }
    }

    void goToNext() {
      if (currentIndex < allSpecies.length - 1) {
        mapProvider.setViewMode(MapViewMode.distribution, speciesId: allSpecies[currentIndex + 1].id);
      } else {
        mapProvider.setViewMode(MapViewMode.distribution, speciesId: allSpecies.first.id);
      }
    }
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(DS.md),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.black.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.antiAlias,
                child: species!.imageUrls.isNotEmpty
                    ? StrobilusImage(imagePath: species!.imageUrls.first, fit: BoxFit.cover)
                    : Container(color: Colors.grey.withValues(alpha: 0.2), child: const Icon(Icons.forest)),
              ),
              const SizedBox(width: DS.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      species!.getCommonName(AppLocalizations.of(context).localeName),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      species!.scientificName,
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade400, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    polygonsLoaded 
                      ? Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: ext.palette.primary, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            const Text('Mes trouvailles', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 12),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: SemanticColors.successLeaf, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text(AppLocalizations.of(context).distributionNativeLabel, style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 12),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text(AppLocalizations.of(context).distributionIntroducedLabel, style: const TextStyle(fontSize: 12)),
                          ],
                        )
                      : Text(AppLocalizations.of(context).loadingMapData, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_up),
                    onPressed: goToPrevious,
                    tooltip: AppLocalizations.of(context).previousSpecies,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onPressed: goToNext,
                    tooltip: AppLocalizations.of(context).nextSpecies,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConeInfoCard extends StatelessWidget {
  final PineConeModel? cone;

  const _ConeInfoCard({this.cone});

  @override
  Widget build(BuildContext context) {
    if (cone == null) return const SizedBox.shrink();
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(DS.md),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.black.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: InkWell(
            onTap: () => context.push('/cone/${cone!.id}'),
            child: Row(
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  clipBehavior: Clip.antiAlias,
                  child: StrobilusImage(
                    imagePath: cone!.photoUrls.isNotEmpty ? cone!.photoUrls.first : null,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: DS.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Collected Cone',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${cone!.collectedAt.day}/${cone!.collectedAt.month}/${cone!.collectedAt.year}',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
