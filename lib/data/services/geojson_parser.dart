import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

class GeoJsonParser {
  static Future<Map<String, List<List<LatLng>>>> loadCountryPolygons() async {
    final Map<String, List<List<LatLng>>> result = {};
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/world_countries.geojson',
      );
      final Map<String, dynamic> geoJson = jsonDecode(jsonString);

      final features = geoJson['features'] as List<dynamic>? ?? [];
      for (var feature in features) {
        final props = feature['properties'] as Map<String, dynamic>?;
        final geom = feature['geometry'] as Map<String, dynamic>?;
        if (props == null || geom == null) continue;

        final id = feature['id'] as String? ?? props['ISO_A3'] as String?;
        if (id == null) continue;

        final type = geom['type'] as String?;
        final coordinates = geom['coordinates'] as List<dynamic>?;
        if (coordinates == null) continue;

        final List<List<LatLng>> polygons = [];

        if (type == 'Polygon') {
          // Polygon is [ [ [lon, lat], ... ] ]
          for (var ring in coordinates) {
            final List<LatLng> points = [];
            for (var point in ring) {
              points.add(
                LatLng(
                  (point[1] as num).toDouble(),
                  (point[0] as num).toDouble(),
                ),
              );
            }
            polygons.add(points);
          }
        } else if (type == 'MultiPolygon') {
          // MultiPolygon is [ [ [ [lon, lat], ... ] ] ]
          for (var polygon in coordinates) {
            for (var ring in polygon) {
              final List<LatLng> points = [];
              for (var point in ring) {
                points.add(
                  LatLng(
                    (point[1] as num).toDouble(),
                    (point[0] as num).toDouble(),
                  ),
                );
              }
              polygons.add(points);
            }
          }
        }

        result[id] = polygons;
      }
    } catch (e) {
      debugPrint('Error loading GeoJSON: $e');
    }
    return result;
  }
}
