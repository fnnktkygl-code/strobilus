import 'dart:math' as math;
import 'package:latlong2/latlong.dart';

class GeoUtils {
  static const double earthRadius =
      6378137.0; // WGS-84 ellipsoid radius in meters

  /// Generates a list of LatLng points representing a circle around [center]
  /// with the given [radiusInMeters].
  static List<LatLng> createCirclePoints(
    LatLng center,
    double radiusInMeters, {
    int points = 32,
  }) {
    final List<LatLng> circlePoints = [];

    // Convert center latitude and longitude to radians
    final double centerLatRad = center.latitude * (math.pi / 180.0);
    final double centerLngRad = center.longitude * (math.pi / 180.0);

    // Angular distance in radians
    final double dRad = radiusInMeters / earthRadius;

    for (int i = 0; i < points; i++) {
      // Angle for this point
      final double bearing = (i * 360 / points) * (math.pi / 180.0);

      // Calculate new latitude
      final double latRad = math.asin(
        math.sin(centerLatRad) * math.cos(dRad) +
            math.cos(centerLatRad) * math.sin(dRad) * math.cos(bearing),
      );

      // Calculate new longitude
      final double lngRad =
          centerLngRad +
          math.atan2(
            math.sin(bearing) * math.sin(dRad) * math.cos(centerLatRad),
            math.cos(dRad) - math.sin(centerLatRad) * math.sin(latRad),
          );

      // Convert back to degrees
      final double lat = latRad * (180.0 / math.pi);
      final double lng = lngRad * (180.0 / math.pi);

      // Ensure longitude is within -180 to 180
      final double normalizedLng = (lng + 540) % 360 - 180;

      circlePoints.add(LatLng(lat, normalizedLng));
    }

    return circlePoints;
  }
}
