class RiskRequest {
  final double lat, lon;
  final DateTime date;
  final int startHour, endHour;
  final String? placeName;

  const RiskRequest({
    required this.lat,
    required this.lon,
    required this.date,
    required this.startHour,
    required this.endHour,
    this.placeName,
  });

  Map<String, dynamic> toQuery() => {
    'lat': lat.toStringAsFixed(4),
    'lon': lon.toStringAsFixed(4),
    'date': date.toIso8601String().split('T').first,
    'startHour': startHour,
    'endHour': endHour,
  };
}

class RiskResponse {
  final String locationName;
  final double rainProbClimo;
  final double? rainProbForecast;
  final double p50Intensity;
  final double p90Intensity;
  final double cloudiness;
  final String heatRisk;
  final String readinessIndex;
  final List<String> rationale;

  const RiskResponse({
    required this.locationName,
    required this.rainProbClimo,
    this.rainProbForecast,
    required this.p50Intensity,
    required this.p90Intensity,
    required this.cloudiness,
    required this.heatRisk,
    required this.readinessIndex,
    required this.rationale,
  });

  factory RiskResponse.fromJson(Map<String, dynamic> j) => RiskResponse(
    locationName: j['location']?['name'] ?? 'Selected location',
    rainProbClimo:
    (j['climatology']?['rainProb'] ?? 0.0).toDouble(),
    rainProbForecast: (j['forecast']?['available'] == true)
        ? (j['forecast']?['rainProb'] ?? 0.0).toDouble()
        : null,
    p50Intensity:
    (j['climatology']?['p50IntensityMmHr'] ?? 0.0).toDouble(),
    p90Intensity:
    (j['climatology']?['p90IntensityMmHr'] ?? 0.0).toDouble(),
    cloudiness: (j['cloudiness'] ?? 0.0).toDouble(),
    heatRisk: j['heatRisk'] ?? 'Unknown',
    readinessIndex: j['readinessIndex'] ?? 'UNKNOWN',
    rationale: (j['rationale'] as List?)?.cast<String>() ?? const [],
  );
}
