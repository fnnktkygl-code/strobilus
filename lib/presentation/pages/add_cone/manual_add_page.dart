import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:strobilus/l10n/app_localizations.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/enum_extensions.dart';
import '../../../core/theme/design_system.dart';
import '../../../data/models/pine_cone_model.dart';
import '../../../data/services/maps_service.dart';
import '../../../presentation/providers/collection_provider.dart';
import '../../../presentation/providers/species_provider.dart';
import '../../../data/models/location_model.dart';
import '../../widgets/common/full_screen_image_viewer.dart';
import '../../widgets/common/strobilus_image.dart';
import '../../widgets/common/location_picker_field.dart';
import '../../widgets/common/strobilus_snack_bar.dart';
import '../../../data/models/species_model.dart';

class ManualAddPage extends StatefulWidget {
  const ManualAddPage({super.key});

  @override
  State<ManualAddPage> createState() => _ManualAddPageState();
}

class _ManualAddPageState extends State<ManualAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  bool _isLoading = false;
  File? _imageFile;
  Position? _location;

  final _commonNameController = TextEditingController();
  final _scientificNameController = TextEditingController();
  final _personalNotesController = TextEditingController();
  LocationModel? _selectedLocation;
  SpeciesModel? _selectedSpecies;

  ConeSize _selectedSize = ConeSize.m;
  ConeCondition _selectedCondition = ConeCondition.good;
  ConeRarity _selectedRarity = ConeRarity.common;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  void dispose() {
    _commonNameController.dispose();
    _scientificNameController.dispose();
    _personalNotesController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    Position? position;
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever) {
          try {
            position = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.medium,
                timeLimit: Duration(seconds: 10),
              ),
            );
          } catch (_) {
            try {
              position = await Geolocator.getLastKnownPosition();
            } catch (_) {}
          }
        }
      }
    } catch (_) {}

    if (position != null) {
      if (mounted) {
        setState(() => _location = position);
        // Automatically resolve current location on mount if available
        final mapsService = context.read<MapsService>();
        final loc = await mapsService.resolveDetailedLocation(
          position.latitude,
          position.longitude,
        );
        if (mounted && loc != null) {
          setState(() => _selectedLocation = loc);
        }
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
        maxHeight: 1600,
      );
      if (picked != null && mounted) {
        setState(() => _imageFile = File(picked.path));
      }
    } catch (e) {
      if (mounted) {
        StrobilusSnackBar.error(
          context,
          '${AppLocalizations.of(context).errorGeneric}: $e',
        );
      }
    }
  }

  Future<void> _saveCone() async {
    if (_imageFile == null) {
      StrobilusSnackBar.error(
        context,
        AppLocalizations.of(context).errorNoPhoto,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context);

    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

      final scientificNameInput = _scientificNameController.text.trim();
      String? matchedSpeciesId;
      if (scientificNameInput.isNotEmpty) {
        final speciesList = context.read<SpeciesProvider>().allSpecies;
        for (final s in speciesList) {
          if (s.scientificName.toLowerCase() ==
              scientificNameInput.toLowerCase()) {
            matchedSpeciesId = s.id;
            break;
          }
        }
      }

      final newCone = PineConeModel(
        id: const Uuid().v4(),
        userId: currentUserId,
        commonName: _commonNameController.text.trim(),
        scientificName: scientificNameInput.isNotEmpty
            ? scientificNameInput
            : null,
        speciesId: _selectedSpecies?.id ?? matchedSpeciesId,
        photoUrls: [
          _imageFile!.path,
        ], // Local path; CollectionProvider uploads it
        latitude:
            _selectedLocation?.latitude ??
            _location?.latitude ??
            AppConstants.defaultMapLat,
        longitude:
            _selectedLocation?.longitude ??
            _location?.longitude ??
            AppConstants.defaultMapLon,
        locationName: _selectedLocation?.locationName ?? l10n.unknownLocation,
        city: _selectedLocation?.city ?? '',
        country: _selectedLocation?.country ?? '',
        countryCode: _selectedLocation?.countryCode ?? '',
        continent: _selectedLocation?.continent ?? l10n.unknownContinent,
        collectedAt: DateTime.now(),
        size: _selectedSize,
        condition: _selectedCondition,
        rarity: _selectedRarity,
        personalNotes: _personalNotesController.text.trim().isNotEmpty
            ? _personalNotesController.text.trim()
            : null,
        isAiIdentified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await context.read<CollectionProvider>().addCone(
        newCone,
        photos: [_imageFile!],
      );

      if (mounted) {
        context.pop();
        StrobilusSnackBar.success(
          context,
          AppLocalizations.of(context).coneAddedSuccess,
        );
      }
    } catch (e) {
      if (mounted) {
        StrobilusSnackBar.error(
          context,
          AppLocalizations.of(context).errorGeneric,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.manualEntryTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading ? null : _saveCone,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(DS.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Picker Section
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: Text(l10n.takePhoto),
                                  onTap: () {
                                    context.pop();
                                    _pickImage(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: Text(l10n.chooseFromGallery),
                                  onTap: () {
                                    context.pop();
                                    _pickImage(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'manual_add_image',
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.2),
                                borderRadius: DS.borderRadiusMd,
                              ),
                              child: _imageFile != null
                                  ? ClipRRect(
                                      borderRadius: DS.borderRadiusMd,
                                      child: StrobilusImage(
                                        imagePath: _imageFile!.path,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate,
                                          size: 50,
                                          color: theme.colorScheme.outline,
                                        ),
                                        const SizedBox(height: DS.sm),
                                        Text(
                                          l10n.tapToSelectPhoto,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          if (_imageFile != null)
                            Positioned(
                              top: DS.sm,
                              right: DS.sm,
                              child: Material(
                                color: Colors.black54,
                                type: MaterialType.circle,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                  ),
                                  tooltip: AppLocalizations.of(
                                    context,
                                  ).viewFullImage,
                                  onPressed: () {
                                    FullScreenImageViewer.show(
                                      context,
                                      imagePath: _imageFile!.path,
                                      isNetwork: false,
                                      heroTag: 'manual_add_image',
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DS.xl),

                    DropdownButtonFormField<SpeciesModel>(
                      decoration: InputDecoration(
                        labelText: l10n.speciesTypeLabel,
                        hintText: l10n.speciesTypeHint,
                        border: const OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      value: _selectedSpecies,
                      items: context.read<SpeciesProvider>().allSpecies.map((
                        SpeciesModel s,
                      ) {
                        final commonName = s.getCommonName(
                          Localizations.localeOf(context).languageCode,
                        );
                        return DropdownMenuItem<SpeciesModel>(
                          value: s,
                          child: Text('$commonName (${s.scientificName})'),
                        );
                      }).toList(),
                      onChanged: (SpeciesModel? selection) {
                        if (selection != null) {
                          setState(() {
                            _selectedSpecies = selection;
                            _commonNameController.text = selection
                                .getCommonName(
                                  Localizations.localeOf(context).languageCode,
                                );
                            _scientificNameController.text =
                                selection.scientificName;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: DS.md),

                    // Form Fields
                    TextFormField(
                      controller: _commonNameController,
                      decoration: InputDecoration(
                        labelText: l10n.commonNameLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DS.md),
                    TextFormField(
                      controller: _scientificNameController,
                      decoration: InputDecoration(
                        labelText: l10n.scientificNameLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: DS.md),

                    // Location Picker Widget
                    LocationPickerField(
                      initialLocation: _selectedLocation,
                      onLocationSelected: (loc) {
                        setState(() => _selectedLocation = loc);
                      },
                    ),
                    const SizedBox(height: DS.lg),

                    // Optional Details Accordion
                    ExpansionTile(
                      title: Text(
                        'Détails optionnels',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      subtitle: Text(
                        'Taille, état, rareté, notes...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: DS.borderRadiusMd,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: DS.borderRadiusMd,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      childrenPadding: const EdgeInsets.all(DS.md),
                      children: [
                        DropdownButtonFormField<ConeSize>(
                          initialValue: _selectedSize,
                          decoration: InputDecoration(
                            labelText: l10n.sizeLabel,
                            border: const OutlineInputBorder(),
                          ),
                          items: ConeSize.values.map((size) {
                            return DropdownMenuItem(
                              value: size,
                              child: Text(size.label(context)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _selectedSize = val);
                          },
                        ),
                        const SizedBox(height: DS.md),

                        DropdownButtonFormField<ConeCondition>(
                          initialValue: _selectedCondition,
                          decoration: InputDecoration(
                            labelText: l10n.conditionLabel,
                            border: const OutlineInputBorder(),
                          ),
                          items: ConeCondition.values.map((cond) {
                            return DropdownMenuItem(
                              value: cond,
                              child: Text(cond.label(context)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedCondition = val);
                            }
                          },
                        ),
                        const SizedBox(height: DS.md),

                        DropdownButtonFormField<ConeRarity>(
                          initialValue: _selectedRarity,
                          decoration: InputDecoration(
                            labelText: l10n.rarityLabel,
                            border: const OutlineInputBorder(),
                          ),
                          items: ConeRarity.values.map((rarity) {
                            return DropdownMenuItem(
                              value: rarity,
                              child: Text(rarity.label(context)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _selectedRarity = val);
                          },
                        ),
                        const SizedBox(height: DS.lg),

                        TextFormField(
                          controller: _personalNotesController,
                          decoration: InputDecoration(
                            labelText: l10n.personalNotes,
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder(),
                            hintText: l10n.notesHint,
                          ),
                          maxLines: 5,
                        ),
                      ],
                    ),
                    const SizedBox(height: DS.xxxl),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveCone,
                        child: Text(l10n.saveManualEntry),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
