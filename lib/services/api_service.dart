// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class ApiException implements Exception {
//   final int statusCode;
//   final String body;
//   ApiException(this.statusCode, this.body);
//   @override
//   String toString() => 'ApiException($statusCode): $body';
// }
//
// class ApiService {
//   final String baseUrl;   // e.g. https://weather-morph.onrender.com/api/forecast/
//   final String queryId;   // e.g. 8d994114-ca4f-4c10-ab39-8e187c7cfaa7
//   final http.Client _client;
//
//   ApiService({
//     required this.baseUrl,
//     required this.queryId,
//     http.Client? client,
//   }) : _client = client ?? http.Client();
//
//   /// GET {baseUrl}?query_id=...&lat=..&lon=..&date=YYYY-MM-DD
//   Future<Map<String, dynamic>> fetchClimatology({
//     required double lat,
//     required double lon,
//     required DateTime date,
//   }) async {
//     final params = <String, String>{
//       'query_id': queryId,
//       'lat': lat.toStringAsFixed(6),
//       'lon': lon.toStringAsFixed(6),
//       'date': date.toIso8601String().split('T').first,
//     };
//
//     final uri = Uri.parse(baseUrl).replace(queryParameters: params);
//
//     final res = await _client
//         .get(uri, headers: {'Accept': 'application/json'})
//         .timeout(const Duration(seconds: 20));
//
//     if (res.statusCode >= 200 && res.statusCode < 300) {
//       final body = res.body.isEmpty ? '{}' : res.body;
//       return jsonDecode(body) as Map<String, dynamic>;
//     }
//     throw ApiException(res.statusCode, res.body);
//   }
//
//   void dispose() => _client.close();
// }





























import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String body;
  ApiException(this.statusCode, this.body);
  @override
  String toString() => 'ApiException($statusCode): $body';
}

class ApiService {
  final String baseUrl;   // e.g., https://weather-morph.onrender.com/api/forecast/
  final String queryId;   // e.g., 8d994114-ca4f-4c10-ab39-8e187c7cfaa7
  final http.Client _client;
  final Duration requestTimeout;

  ApiService({
    required this.baseUrl,
    required this.queryId,
    http.Client? client,
    Duration? requestTimeout,
  })  : _client = client ?? http.Client(),
        requestTimeout = requestTimeout ?? const Duration(seconds: 60);

  Future<Map<String, dynamic>> fetchClimatology({
    required double lat,
    required double lon,
    required DateTime date,
  }) async {
    final params = <String, String>{
      'query_id': queryId,
      'lat': lat.toStringAsFixed(6),
      'lon': lon.toStringAsFixed(6),
      'date': date.toIso8601String().split('T').first,
    };
    final uri = Uri.parse(baseUrl).replace(queryParameters: params);

    // retry up to 3 times (0s, 2s, 5s)
    final delays = <Duration>[Duration.zero, const Duration(seconds: 2), const Duration(seconds: 5)];
    Object? lastErr;

    for (final d in delays) {
      if (d > Duration.zero) {
        await Future.delayed(d);
      }
      try {
        final res = await _client
            .get(uri, headers: {'Accept': 'application/json'})
            .timeout(requestTimeout);

        if (res.statusCode >= 200 && res.statusCode < 300) {
          final body = res.body.isEmpty ? '{}' : res.body;
          return jsonDecode(body) as Map<String, dynamic>;
        }
        throw ApiException(res.statusCode, res.body);
      } on TimeoutException catch (e) {
        lastErr = e; // try again
      } on http.ClientException catch (e) {
        lastErr = e; // network hiccup — try again
      }
    }
    // after retries
    throw lastErr ?? TimeoutException('Request timed out after retries');
  }

  void dispose() => _client.close();
}


