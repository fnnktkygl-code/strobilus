import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:strobilus/l10n/app_localizations.dart';

import '../../../core/theme/design_system.dart';
import '../../../data/models/location_model.dart';
import '../../../data/services/maps_service.dart';

class LocationPickerField extends StatefulWidget {
  final LocationModel? initialLocation;
  final ValueChanged<LocationModel?> onLocationSelected;

  const LocationPickerField({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
  });

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  LocationModel? _selectedLocation;
  bool _isLoading = false;
  final _searchController = TextEditingController();
  List<LocationModel> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _isSearching = false;
    });

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever) {
          Position? position;
          try {
            position = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.medium,
                timeLimit: Duration(seconds: 5),
              ),
            );
          } catch (e) {
            position = await Geolocator.getLastKnownPosition();
            if (position == null) rethrow;
          }

          if (mounted) {
            final mapsService = context.read<MapsService>();
            final loc = await mapsService.resolveDetailedLocation(
              position.latitude,
              position.longitude,
            );
            if (loc != null) {
              setState(() {
                _selectedLocation = loc;
              });
              widget.onLocationSelected(loc);
            }
          }
        }
      }
    } catch (e) {
      // Silently fail if location cannot be determined, allowing manual selection
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSearchDialog() {
    _searchController.clear();
    _searchResults = [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final theme = Theme.of(context);
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(DS.md)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(DS.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).collectionSearch,
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setModalState(() {
                                        _searchResults = [];
                                      });
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(DS.sm),
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                          ),
                          onSubmitted: (val) async {
                            setModalState(() => _isSearching = true);
                            final mapsService = context.read<MapsService>();
                            final results = await mapsService.searchLocation(val);
                            if (mounted) {
                              setModalState(() {
                                _searchResults = results;
                                _isSearching = false;
                              });
                            }
                          },
                          onChanged: (val) {
                            setModalState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: DS.sm),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(AppLocalizations.of(context).locationPickerClose),
                      ),
                    ],
                  ),
                ),
                if (_isSearching)
                  const Padding(
                    padding: EdgeInsets.all(DS.lg),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(DS.lg),
                    child: Center(child: Text(AppLocalizations.of(context).locationPickerNoResults)),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final res = _searchResults[index];
                        return ListTile(
                          leading: Icon(Icons.location_on, color: theme.colorScheme.primary),
                          title: Text(res.locationName),
                          subtitle: Text('${res.city.isNotEmpty ? '${res.city}, ' : ''}${res.country} (${res.countryCode})'),
                          onTap: () {
                            setState(() {
                              _selectedLocation = res;
                            });
                            widget.onLocationSelected(res);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(DS.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(DS.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.map, color: theme.colorScheme.primary),
              const SizedBox(width: DS.sm),
              Text(
                AppLocalizations.of(context).locationNameLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: DS.md),
          if (_selectedLocation != null)
            Container(
              padding: const EdgeInsets.all(DS.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(DS.sm),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: DS.sm),
                  Expanded(
                    child: Text(
                      '${_selectedLocation!.locationName}\n${_selectedLocation!.city.isNotEmpty ? '${_selectedLocation!.city}, ' : ''}${_selectedLocation!.country}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      setState(() => _selectedLocation = null);
                      widget.onLocationSelected(null);
                    },
                  ),
                ],
              ),
            )
          else
            Text(
              AppLocalizations.of(context).gpsUnavailable,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: DS.md),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _fetchCurrentLocation,
                  icon: _isLoading 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.my_location, size: 18),
                  label: Text(AppLocalizations.of(context).locationPickerGps),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: DS.sm),
                  ),
                ),
              ),
              const SizedBox(width: DS.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _showSearchDialog,
                  icon: const Icon(Icons.search, size: 18),
                  label: Text(AppLocalizations.of(context).locationPickerSearch),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: DS.sm),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
