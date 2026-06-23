import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/storage_keys.dart';
import '../../core/errors/exceptions.dart';

/// Identification result from Gemini AI.
class ConeIdentificationResult {
  final bool identified;
  final String confidence; // high, medium, low
  final List<SpeciesMatch> topMatches;
  final ConeCharacteristics? characteristics;

  const ConeIdentificationResult({
    required this.identified,
    required this.confidence,
    required this.topMatches,
    this.characteristics,
  });

  factory ConeIdentificationResult.fromJson(Map<String, dynamic> json) {
    return ConeIdentificationResult(
      identified: json['identified'] as bool? ?? false,
      confidence: json['confidence'] as String? ?? 'low',
      topMatches:
          (json['topMatches'] as List?)
              ?.map((e) => SpeciesMatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      characteristics: json['characteristics'] != null
          ? ConeCharacteristics.fromJson(
              json['characteristics'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class SpeciesMatch {
  final String scientificName;
  final String commonName;
  final int confidencePercent;
  final String reasoningBrief;

  const SpeciesMatch({
    required this.scientificName,
    required this.commonName,
    required this.confidencePercent,
    required this.reasoningBrief,
  });

  factory SpeciesMatch.fromJson(Map<String, dynamic> json) {
    return SpeciesMatch(
      scientificName: json['scientificName'] as String? ?? '',
      commonName: json['commonName'] as String? ?? '',
      confidencePercent: json['confidencePercent'] as int? ?? 0,
      reasoningBrief: json['reasoningBrief'] as String? ?? '',
    );
  }
}

class ConeCharacteristics {
  final String estimatedSize;
  final String estimatedCondition;
  final String shape;
  final String colorDescription;
  final String? umboPosition; // "dorsal" or "terminal"
  final bool? hasMucro;
  final bool? isSerotinous;
  final int? estimatedNeedlesPerFascicle;

  const ConeCharacteristics({
    required this.estimatedSize,
    required this.estimatedCondition,
    required this.shape,
    required this.colorDescription,
    this.umboPosition,
    this.hasMucro,
    this.isSerotinous,
    this.estimatedNeedlesPerFascicle,
  });

  factory ConeCharacteristics.fromJson(Map<String, dynamic> json) {
    return ConeCharacteristics(
      estimatedSize: json['estimatedSize'] as String? ?? 'm',
      estimatedCondition: json['estimatedCondition'] as String? ?? 'good',
      shape: json['shape'] as String? ?? '',
      colorDescription: json['colorDescription'] as String? ?? '',
      umboPosition: json['umboPosition'] as String?,
      hasMucro: json['hasMucro'] as bool?,
      isSerotinous: json['isSerotinous'] as bool?,
      estimatedNeedlesPerFascicle: json['estimatedNeedlesPerFascicle'] as int?,
    );
  }
}

/// Direct Gemini API service (free tier, no Cloud Functions needed).
class GeminiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.geminiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  final _storage = const FlutterSecureStorage();
  final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Check if we can make an AI call today.
  Future<bool> canMakeCall() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString(StorageKeys.aiCallDate);
    final count = prefs.getInt(StorageKeys.aiCallCount) ?? 0;

    if (savedDate != today) return true;
    return count < AppConstants.maxDailyAiCalls;
  }

  /// Increment the daily call counter.
  Future<void> _incrementCallCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString(StorageKeys.aiCallDate);

    if (savedDate != today) {
      await prefs.setString(StorageKeys.aiCallDate, today);
      await prefs.setInt(StorageKeys.aiCallCount, 1);
    } else {
      final count = prefs.getInt(StorageKeys.aiCallCount) ?? 0;
      await prefs.setInt(StorageKeys.aiCallCount, count + 1);
    }
  }

  /// Identify a pine cone from a photo, optionally using location context.
  Future<ConeIdentificationResult> identifyCone(
    String imagePath, {
    double? lat,
    double? lon,
    String? locationContext,
  }) async {
    if (!await canMakeCall()) {
      throw const RateLimitException('Daily AI identification limit reached.');
    }

    final key =
        dotenv.env['GEMINI_API_KEY'] ??
        await _storage.read(key: StorageKeys.geminiApiKey);
    if (key == null || key.isEmpty) {
      throw const MissingApiKeyException();
    }

    List<int> bytes;
    if (imagePath.startsWith('http')) {
      final response = await _dio.get<List<int>>(
        imagePath,
        options: Options(responseType: ResponseType.bytes),
      );
      bytes = response.data!;
    } else {
      bytes = await File(imagePath).readAsBytes();
    }
    final base64Image = base64Encode(bytes);

    try {
      final response = await _dio.post(
        'models/${AppConstants.geminiModel}:generateContent',
        queryParameters: {'key': key},
        data: {
          'contents': [
            {
              'parts': [
                {
                  'inlineData': {'mimeType': 'image/jpeg', 'data': base64Image},
                },
                {
                  'text': _buildPrompt(
                    lat: lat,
                    lon: lon,
                    locationContext: locationContext,
                  ),
                },
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.1,
            'responseMimeType': 'application/json',
          },
        },
      );

      await _incrementCallCount();

      final text =
          response.data['candidates'][0]['content']['parts'][0]['text']
              as String;
      final json = jsonDecode(text) as Map<String, dynamic>;
      return ConeIdentificationResult.fromJson(json);
    } catch (e) {
      _logger.e('Gemini identification failed: $e');
      rethrow;
    }
  }

  String _buildPrompt({double? lat, double? lon, String? locationContext}) {
    String contextString = '';
    if (lat != null && lon != null) {
      contextString =
          '''
GEOGRAPHIC CONTEXT (use as Bayesian spatial prior):
Location: latitude $lat, longitude $lon${locationContext != null && locationContext.isNotEmpty ? ' near $locationContext' : ''}.
CRITICAL: Heavily weight native species for this floristic zone. If the cone morphology is ambiguous, use geography to break ties. However, remember that many species (P. nigra, P. pinea, P. radiata, etc.) are widely planted as ornamentals outside their native range.''';
    }

    return '''You are an expert conifer taxonomist and morphologist specializing in Pinaceae identification from cone morphology.
$contextString

KNOWN SPECIES DATABASE (42 species):
Pinus: P. sylvestris, P. pinea, P. nigra, P. halepensis, P. pinaster, P. cembra, P. mugo, P. strobus, P. lambertiana, P. canariensis, P. coulteri, P. ponderosa, P. contorta, P. banksiana, P. radiata, P. taeda, P. palustris, P. albicaulis, P. aristata, P. longaeva, P. edulis, P. resinosa, P. rigida, P. echinata, P. attenuata, P. maximartinezii, P. brutia, P. wallichiana, P. jeffreyi, P. densiflora, P. koraiensis, P. cembroides, P. monticola, P. virginiana, P. caribaea, P. pumila.
Other conifers: Picea abies, Abies alba, Cedrus atlantica, Sequoiadendron giganteum, Araucaria araucana, Larix decidua.

KEY MORPHOLOGICAL DISCRIMINATORS TO ANALYZE:
1. UMBO POSITION: Dorsal (Diploxylon/hard pines) vs Terminal (Haploxylon/soft pines) — this determines subgenus
2. MUCRO/SPINE: Presence of a prickle on the umbo (key for P. nigra, P. contorta, P. taeda)
3. APOPHYSIS SHAPE: Flat, rhomboidal, pyramidal (P. pinaster), hooked (P. coulteri), rounded (P. pinea)
4. SEROTINY: Sealed/closed cones (P. contorta, P. banksiana, P. radiata, P. attenuata)
5. ASYMMETRY: Many serotinous species have asymmetric cones
6. CONE SIZE: From tiny (P. mugo 2cm) to enormous (P. lambertiana 60cm, P. coulteri 40cm)
7. SCALE TEXTURE: Thin/papery (Picea) vs thick/woody (Pinus) vs barrel-shaped (Cedrus)

Analyze this cone image and identify the species. Return a JSON object with this exact schema:
{
  "identified": boolean,
  "confidence": "high" | "medium" | "low",
  "topMatches": [
    {
      "scientificName": string,
      "commonName": string,
      "confidencePercent": number (0-100),
      "reasoningBrief": string (explain key morphological features that led to this identification)
    }
  ],
  "characteristics": {
    "estimatedSize": "xs" | "s" | "m" | "l" | "xl",
    "estimatedCondition": "pristine" | "good" | "worn" | "fragmented",
    "shape": string,
    "colorDescription": string,
    "umboPosition": "dorsal" | "terminal" | null,
    "hasMucro": boolean | null,
    "isSerotinous": boolean | null,
    "estimatedNeedlesPerFascicle": number | null
  }
}
Return ONLY valid JSON. No markdown, no preamble.''';
  }

  /// Store the API key securely on first launch.
  Future<void> storeApiKey(String key) async {
    await _storage.write(key: StorageKeys.geminiApiKey, value: key);
  }

  /// Check if API key is configured.
  Future<bool> hasApiKey() async {
    if (dotenv.env['GEMINI_API_KEY']?.isNotEmpty == true) return true;
    final key = await _storage.read(key: StorageKeys.geminiApiKey);
    return key != null && key.isNotEmpty;
  }
}
