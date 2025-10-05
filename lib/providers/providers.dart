import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

// Use --dart-define to override in production if needed.
const _defaultBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://weather-morph.onrender.com/api/forecast/',
);

const _defaultQueryId = String.fromEnvironment(
  'QUERY_ID',
  defaultValue: '882c82de-652e-4b11-a85b-dc70cefb9549',
);

// Provide the ApiService globally.
// final apiServiceProvider = Provider<ApiService>((ref) {
//   final svc = ApiService(baseUrl: _defaultBaseUrl, queryId: _defaultQueryId);
//   ref.onDispose(svc.dispose);
//   return svc;
// });

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(
    baseUrl: 'https://weather-morph.onrender.com/api/forecast/',
    queryId: '882c82de-652e-4b11-a85b-dc70cefb9549',
  );
});

// Simple record type for the request data.
typedef RiskRequestRecord = ({double lat, double lon, DateTime date});

final riskRequestProvider = StateProvider<RiskRequestRecord?>((_) => null);

final riskResultProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final req = ref.watch(riskRequestProvider);
  final api = ref.read(apiServiceProvider);

  if (req == null) {
    // Default fallback
    return api.fetchClimatology(
      lat: 24.8607,
      lon: 67.0011,
      date: DateTime.now(),
    );
  }

  return api.fetchClimatology(
    lat: req.lat,
    lon: req.lon,
    date: req.date,
  );
});
