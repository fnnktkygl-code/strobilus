import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:strobilus/l10n/app_localizations.dart';

import '../../../core/theme/design_system.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/router/route_names.dart';
import '../../../data/models/location_model.dart';
import '../../../data/models/pine_cone_model.dart';
import '../../../data/services/gemini_service.dart';
import '../../../data/services/maps_service.dart';
import '../../../presentation/providers/collection_provider.dart';
import '../../../presentation/providers/species_provider.dart';
import '../../widgets/common/full_screen_image_viewer.dart';
import '../../widgets/common/location_picker_field.dart';
import '../../widgets/common/strobilus_snack_bar.dart';

/// Single-screen "Quick Capture" flow using AI and progressive location.
class QuickCapturePage extends StatefulWidget {
  const QuickCapturePage({super.key});

  @override
  State<QuickCapturePage> createState() => _QuickCapturePageState();
}

enum CaptureState { viewfinder, processing, review }

class _QuickCapturePageState extends State<QuickCapturePage>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  CaptureState _state = CaptureState.viewfinder;

  // Scan animation
  AnimationController? _scanController;
  AnimationController? _pulseController;
  int _scanTextIndex = 0;

  // Captured Data
  File? _capturedImage;
  Position? _currentPosition;
  LocationModel? _resolvedLocation;
  ConeIdentificationResult? _aiResult;
  String? _locationStatusKey; // l10n key resolved in build

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initLocation();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _initLocation() async {
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
    } catch (e) {
      debugPrint('Geolocator error bypassed: $e');
    }

    if (position == null) {
      if (mounted) {
        setState(() {
          _locationStatusKey = 'gpsUnavailableShort';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _locationStatusKey = 'gpsLocked';
        });
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (_cameraController!.value.isTakingPicture) return;

    try {
      final mapsService = context.read<MapsService>();

      final xFile = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = File(xFile.path);
        _state = CaptureState.processing;
      });

      // Location Resolution
      LocationModel? resolvedLoc;
      if (_currentPosition != null) {
        resolvedLoc = await mapsService.resolveDetailedLocation(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        if (mounted && resolvedLoc != null) {
          setState(() {
            _resolvedLocation = resolvedLoc;
          });
        }
      }

      if (mounted) {
        setState(() {
          _state = CaptureState.review;
        });
      }
    } catch (e) {
      if (mounted) {
        StrobilusSnackBar.error(
          context,
          AppLocalizations.of(context).cameraError,
        );
        setState(() => _state = CaptureState.viewfinder);
      }
    }
  }

  Future<void> _identifyWithAI() async {
    if (_capturedImage == null) return;

    setState(() {
      _state = CaptureState.processing;
      _scanTextIndex = 0;
    });
    _scanController!.repeat();
    _pulseController!.repeat(reverse: true);
    // Cycle scan text
    _cycleScanText();

    try {
      final locale = Localizations.localeOf(context).languageCode;
      final geminiService = context.read<GeminiService>();
      final aiResult = await geminiService.identifyCone(
        _capturedImage!.path,
        lat: _currentPosition?.latitude,
        lon: _currentPosition?.longitude,
        locationContext: _resolvedLocation?.locationName,
        languageCode: locale,
      );

      _stopScanAnimation();
      if (mounted) {
        setState(() {
          _aiResult = aiResult;
          _state = CaptureState.review;
        });
      }
    } on AiNetworkException catch (_) {
      _stopScanAnimation();
      if (mounted) {
        setState(() {
          _aiResult = null;
          _state = CaptureState.review;
        });
        StrobilusSnackBar.error(
          context,
          'Erreur réseau. Vérifiez votre connexion Internet.',
        );
      }
    } on AiQuotaException catch (_) {
      _stopScanAnimation();
      if (mounted) {
        setState(() {
          _aiResult = null;
          _state = CaptureState.review;
        });
        StrobilusSnackBar.error(
          context,
          "Limite quotidienne d'identification atteinte. Réessayez demain !",
        );
      }
    } on AiInvalidImageException catch (_) {
      _stopScanAnimation();
      if (mounted) {
        setState(() {
          _aiResult = null;
          _state = CaptureState.review;
        });
        StrobilusSnackBar.error(
          context,
          "L'image n'est pas claire ou n'est pas une pomme de pin.",
        );
      }
    } catch (e) {
      _stopScanAnimation();
      if (mounted) {
        setState(() {
          _aiResult = null;
          _state = CaptureState.review;
        });
        StrobilusSnackBar.error(
          context,
          AppLocalizations.of(context).aiIdentificationFailed,
        );
      }
    }
  }

  Future<void> _saveToCollection({bool navigateToEdit = false}) async {
    if (_capturedImage == null) return;

    final collection = context.read<CollectionProvider>();
    setState(() => _state = CaptureState.processing);

    final now = DateTime.now();
    final isIdentified = _aiResult != null;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Parse size and condition
    ConeSize parsedSize = ConeSize.m;
    ConeCondition parsedCondition = ConeCondition.good;

    if (_aiResult?.characteristics != null) {
      final chars = _aiResult!.characteristics!;
      parsedSize = ConeSize.values.firstWhere(
        (e) => e.name.toLowerCase() == chars.estimatedSize.toLowerCase(),
        orElse: () => ConeSize.m,
      );
      parsedCondition = ConeCondition.values.firstWhere(
        (e) => e.name.toLowerCase() == chars.estimatedCondition.toLowerCase(),
        orElse: () => ConeCondition.good,
      );
    }

    String? matchedSpeciesId;
    String? matchedCommonName;
    if (_aiResult?.topMatches.isNotEmpty == true) {
      final scientificName = _aiResult!.topMatches.first.scientificName
          .toLowerCase();
      final speciesList = context.read<SpeciesProvider>().allSpecies;
      for (final s in speciesList) {
        final sName = s.scientificName.toLowerCase();
        if (sName == scientificName ||
            sName.contains(scientificName) ||
            scientificName.contains(sName)) {
          matchedSpeciesId = s.id;
          final locale = Localizations.localeOf(context).languageCode;
          matchedCommonName = s.getCommonName(locale);
          break;
        }
      }
    }

    final cone = PineConeModel(
      id: const Uuid().v4(),
      userId: currentUserId,
      commonName:
          matchedCommonName ??
          (_aiResult?.topMatches.isNotEmpty == true
              ? _aiResult!.topMatches.first.commonName
              : AppLocalizations.of(context).unknownCone),
      scientificName: _aiResult?.topMatches.isNotEmpty == true
          ? _aiResult!.topMatches.first.scientificName
          : null,
      speciesId: matchedSpeciesId,
      photoUrls: [_capturedImage!.path], // Save local path
      latitude:
          _resolvedLocation?.latitude ?? _currentPosition?.latitude ?? 0.0,
      longitude:
          _resolvedLocation?.longitude ?? _currentPosition?.longitude ?? 0.0,
      locationName:
          _resolvedLocation?.locationName ??
          AppLocalizations.of(context).unknownLocation,
      city: _resolvedLocation?.city ?? '',
      country: _resolvedLocation?.country ?? '',
      countryCode: _resolvedLocation?.countryCode ?? '',
      continent:
          _resolvedLocation?.continent ??
          AppLocalizations.of(context).unknownContinent,
      collectedAt: now,
      size: parsedSize,
      condition: parsedCondition,
      rarity: ConeRarity.common,
      habitat: ConeHabitat.forest.name,
      isAiIdentified: isIdentified,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await collection.addCone(cone, photos: [_capturedImage!]);
      if (mounted) {
        StrobilusSnackBar.success(
          context,
          AppLocalizations.of(context).coneSavedSuccess,
        );
        if (navigateToEdit) {
          context.pushReplacementNamed(
            RouteNames.editCone,
            pathParameters: {'coneId': cone.id},
          );
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        StrobilusSnackBar.error(
          context,
          AppLocalizations.of(context).errorGeneric,
        );
        setState(() => _state = CaptureState.review); // Revert state on error
      }
    }
  }

  void _stopScanAnimation() {
    _scanController?.stop();
    _scanController?.reset();
    _pulseController?.stop();
    _pulseController?.reset();
  }

  Future<void> _cycleScanText() async {
    for (int i = 0; i < 4; i++) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted || _state != CaptureState.processing) return;
      setState(() => _scanTextIndex = (i + 1) % 4);
    }
  }

  String _getScanText(AppLocalizations l10n) {
    switch (_scanTextIndex) {
      case 0:
        return l10n.scanStep1;
      case 1:
        return l10n.scanStep2;
      case 2:
        return l10n.scanStep3;
      default:
        return l10n.scanStep4;
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _scanController?.dispose();
    _pulseController?.dispose();
    super.dispose();
  }

  String _resolveLocationStatus(AppLocalizations l10n) {
    switch (_locationStatusKey) {
      case 'gpsLocked':
        return l10n.gpsLocked;
      case 'gpsUnavailableShort':
        return l10n.gpsUnavailableShort;
      default:
        return l10n.locating;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background: Camera or Captured Image
          if (_state == CaptureState.viewfinder &&
              _cameraController?.value.isInitialized == true)
            CameraPreview(_cameraController!)
          else if (_capturedImage != null)
            GestureDetector(
              onTap: () {
                FullScreenImageViewer.show(
                  context,
                  imagePath: _capturedImage!.path,
                  isNetwork: false,
                  heroTag: 'quick_capture_image',
                );
              },
              child: Hero(
                tag: 'quick_capture_image',
                child: Image.file(_capturedImage!, fit: BoxFit.cover),
              ),
            ),

          // Top Bar (Close + GPS Status)
          Positioned(
            top: MediaQuery.of(context).padding.top + DS.sm,
            left: DS.md,
            right: DS.md,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                  onPressed: () => context.pop(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DS.md,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _currentPosition != null
                            ? Icons.gps_fixed
                            : Icons.gps_not_fixed,
                        color: _currentPosition != null
                            ? theme.colorScheme.primary
                            : Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _resolveLocationStatus(l10n),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Processing Overlay — Animated Scan
          if (_state == CaptureState.processing)
            AnimatedBuilder(
              animation: Listenable.merge([
                _scanController!,
                _pulseController!,
              ]),
              builder: (context, child) {
                return Container(
                  color: Colors.black.withValues(alpha: 0.6),
                  child: Stack(
                    children: [
                      // Scan line
                      Positioned(
                        top:
                            MediaQuery.of(context).size.height *
                            _scanController!.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                theme.colorScheme.primary.withValues(
                                  alpha: 0.8,
                                ),
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withValues(
                                  alpha: 0.8,
                                ),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                                blurRadius: 16,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Center content
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Pulsing icon
                            Transform.scale(
                              scale: 1.0 + (_pulseController!.value * 0.2),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  border: Border.all(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                            const SizedBox(height: DS.lg),
                            // Animated text
                            AnimatedSwitcher(
                              duration: DS.medium,
                              child: Text(
                                _getScanText(l10n),
                                key: ValueKey(_scanTextIndex),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Viewfinder Controls
          if (_state == CaptureState.viewfinder)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _capturePhoto,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Review Bottom Sheet
          if (_state == CaptureState.review)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(DS.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(DS.borderRadiusXl.bottomLeft.x),
                  ),
                  boxShadow: DS.shadowCard(theme),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_aiResult != null) ...[
                        Text(l10n.done, style: theme.textTheme.labelMedium),
                        const SizedBox(height: DS.sm),
                        Text(
                          _aiResult!.topMatches.isNotEmpty
                              ? _aiResult!.topMatches.first.commonName
                              : l10n.unknownSpecies,
                          style: theme.textTheme.headlineSmall,
                        ),
                        if (_aiResult!.topMatches.isNotEmpty)
                          Text(
                            _aiResult!.topMatches.first.scientificName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ] else ...[
                        Text(
                          l10n.stepDetails,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                      const SizedBox(height: DS.md),
                      LocationPickerField(
                        initialLocation: _resolvedLocation,
                        onLocationSelected: (loc) {
                          setState(() => _resolvedLocation = loc);
                        },
                      ),
                      const SizedBox(height: DS.lg),
                      if (_aiResult == null) ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.auto_awesome),
                            label: Text(l10n.aiIdentifyButton),
                            onPressed: _identifyWithAI,
                          ),
                        ),
                        const SizedBox(height: DS.md),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  _saveToCollection(navigateToEdit: true),
                              child: Text(l10n.editDetails),
                            ),
                          ),
                          const SizedBox(width: DS.md),
                          Expanded(
                            flex: _aiResult == null ? 1 : 2,
                            child: ElevatedButton(
                              onPressed: _saveToCollection,
                              child: Text(l10n.save),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
