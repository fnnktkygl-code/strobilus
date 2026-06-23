import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../models/location_model.dart';
import '../../core/constants/app_constants.dart';

/// Reverse geocoding using Nominatim (free, no API key).
class MapsService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.nominatimBaseUrl,
      headers: {'User-Agent': AppConstants.nominatimUserAgent},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  DateTime? _lastRequestTime;

  /// Reverse geocode coordinates to a location name.
  /// Respects Nominatim rate limit (max 1 req/sec).
  Future<LocationModel?> reverseGeocode(double lat, double lon) async {
    // Rate limiting
    if (_lastRequestTime != null) {
      final elapsed = DateTime.now().difference(_lastRequestTime!);
      if (elapsed < AppConstants.nominatimRateLimit) {
        await Future.delayed(AppConstants.nominatimRateLimit - elapsed);
      }
    }

    try {
      _lastRequestTime = DateTime.now();

      final response = await _dio.get(
        '/reverse',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'format': 'json',
          'accept-language': 'en',
          'addressdetails': 1,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return LocationModel.fromNominatim(
          response.data as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      _logger.w('Reverse geocode failed: $e');
      return null;
    }
  }

  /// Search for a location by query.
  Future<List<LocationModel>> searchLocation(String query) async {
    // Rate limiting
    if (_lastRequestTime != null) {
      final elapsed = DateTime.now().difference(_lastRequestTime!);
      if (elapsed < AppConstants.nominatimRateLimit) {
        await Future.delayed(AppConstants.nominatimRateLimit - elapsed);
      }
    }

    try {
      _lastRequestTime = DateTime.now();

      final response = await _dio.get(
        '/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'accept-language': 'en',
          'addressdetails': 1,
          'limit': 5,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final list = response.data as List<dynamic>;
        return list
            .map((e) => LocationModel.fromNominatim(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      _logger.w('Search geocode failed: $e');
      return [];
    }
  }

  /// Progressive location stack: Nominatim -> Overpass API.
  /// Fetches base city/country, then attempts to find local park/forest name.
  Future<LocationModel?> resolveDetailedLocation(double lat, double lon) async {
    var loc = await reverseGeocode(lat, lon);
    if (loc == null) return null;

    try {
      // Overpass query: find if we are inside a park, forest, wood, or nature reserve
      final overpassQuery =
          '[out:json];is_in($lat,$lon)->.a;way(pivot.a)[~"leisure|landuse|natural"~"park|forest|wood|nature_reserve"];out tags;';

      final response = await _dio.get(
        'https://overpass-api.de/api/interpreter',
        queryParameters: {'data': overpassQuery},
        options: Options(receiveTimeout: const Duration(seconds: 5)),
      );

      if (response.statusCode == 200 && response.data != null) {
        final elements = response.data['elements'] as List?;
        if (elements != null && elements.isNotEmpty) {
          final tags = elements.first['tags'] as Map<String, dynamic>?;
          if (tags != null && tags['name'] != null) {
            loc = loc.copyWith(locationName: tags['name'] as String);
          }
        }
      }
    } catch (e) {
      _logger.w('Overpass query failed: $e');
      // Non-fatal, just return the Nominatim location
    }

    return loc;
  }
}
