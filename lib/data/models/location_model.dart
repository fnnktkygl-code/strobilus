import 'package:hive/hive.dart';
import '../../core/utils/iso_country_mapper.dart';

part 'location_model.g.dart';

/// Geocoded location data.
@HiveType(typeId: 2)
class LocationModel extends HiveObject {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final String locationName;

  @HiveField(3)
  final String city;

  @HiveField(4)
  final String country;

  @HiveField(5)
  final String countryCode;

  @HiveField(6)
  final String continent;

  @HiveField(7)
  final double? elevation;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.city,
    required this.country,
    required this.countryCode,
    required this.continent,
    this.elevation,
  });

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? locationName,
    String? city,
    String? country,
    String? countryCode,
    String? continent,
    double? elevation,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      city: city ?? this.city,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      continent: continent ?? this.continent,
      elevation: elevation ?? this.elevation,
    );
  }

  factory LocationModel.fromNominatim(Map<String, dynamic> data) {
    final address = data['address'] as Map<String, dynamic>? ?? {};
    final countryCode = IsoCountryMapper.convertIso2To3(
      (address['country_code'] as String? ?? '').toUpperCase(),
    );

    return LocationModel(
      latitude: double.tryParse(data['lat']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(data['lon']?.toString() ?? '') ?? 0.0,
      locationName: data['display_name'] as String? ?? '',
      city:
          address['city'] as String? ??
          address['town'] as String? ??
          address['village'] as String? ??
          address['municipality'] as String? ??
          '',
      country: address['country'] as String? ?? '',
      countryCode: countryCode,
      continent: _getContinentFromCountryCode(countryCode),
    );
  }

  static String _getContinentFromCountryCode(String code) {
    const europeCodes = {
      'AL',
      'AD',
      'AT',
      'BY',
      'BE',
      'BA',
      'BG',
      'HR',
      'CY',
      'CZ',
      'DK',
      'EE',
      'FI',
      'FR',
      'DE',
      'GR',
      'HU',
      'IS',
      'IE',
      'IT',
      'XK',
      'LV',
      'LI',
      'LT',
      'LU',
      'MT',
      'MD',
      'MC',
      'ME',
      'NL',
      'MK',
      'NO',
      'PL',
      'PT',
      'RO',
      'RU',
      'SM',
      'RS',
      'SK',
      'SI',
      'ES',
      'SE',
      'CH',
      'TR',
      'UA',
      'GB',
      'VA',
    };
    const asiaCodes = {
      'AF',
      'AM',
      'AZ',
      'BH',
      'BD',
      'BT',
      'BN',
      'KH',
      'CN',
      'GE',
      'IN',
      'ID',
      'IR',
      'IQ',
      'IL',
      'JP',
      'JO',
      'KZ',
      'KW',
      'KG',
      'LA',
      'LB',
      'MY',
      'MV',
      'MN',
      'MM',
      'NP',
      'KP',
      'OM',
      'PK',
      'PS',
      'PH',
      'QA',
      'SA',
      'SG',
      'KR',
      'LK',
      'SY',
      'TW',
      'TJ',
      'TH',
      'TL',
      'TM',
      'AE',
      'UZ',
      'VN',
      'YE',
    };
    const africaCodes = {
      'DZ',
      'AO',
      'BJ',
      'BW',
      'BF',
      'BI',
      'CM',
      'CV',
      'CF',
      'TD',
      'KM',
      'CD',
      'CG',
      'CI',
      'DJ',
      'EG',
      'GQ',
      'ER',
      'SZ',
      'ET',
      'GA',
      'GM',
      'GH',
      'GN',
      'GW',
      'KE',
      'LS',
      'LR',
      'LY',
      'MG',
      'MW',
      'ML',
      'MR',
      'MU',
      'MA',
      'MZ',
      'NA',
      'NE',
      'NG',
      'RW',
      'ST',
      'SN',
      'SC',
      'SL',
      'SO',
      'ZA',
      'SS',
      'SD',
      'TZ',
      'TG',
      'TN',
      'UG',
      'ZM',
      'ZW',
    };
    const northAmericaCodes = {
      'AG',
      'BS',
      'BB',
      'BZ',
      'CA',
      'CR',
      'CU',
      'DM',
      'DO',
      'SV',
      'GD',
      'GT',
      'HT',
      'HN',
      'JM',
      'MX',
      'NI',
      'PA',
      'KN',
      'LC',
      'VC',
      'TT',
      'US',
    };
    const southAmericaCodes = {
      'AR',
      'BO',
      'BR',
      'CL',
      'CO',
      'EC',
      'GY',
      'PY',
      'PE',
      'SR',
      'UY',
      'VE',
    };
    const oceaniaCodes = {
      'AU',
      'FJ',
      'KI',
      'MH',
      'FM',
      'NR',
      'NZ',
      'PW',
      'PG',
      'WS',
      'SB',
      'TO',
      'TV',
      'VU',
    };

    if (europeCodes.contains(code)) return 'Europe';
    if (asiaCodes.contains(code)) return 'Asia';
    if (africaCodes.contains(code)) return 'Africa';
    if (northAmericaCodes.contains(code)) return 'North America';
    if (southAmericaCodes.contains(code)) return 'South America';
    if (oceaniaCodes.contains(code)) return 'Oceania';
    return 'Unknown';
  }
}
