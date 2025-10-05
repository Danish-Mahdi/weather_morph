import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

final cacheServiceProvider = Provider<CacheService>((_) => CacheService());

class CacheService {
  static const _boxName = 'riskCache';
  static bool _init = false;

  Future<void> _ensure() async {
    if (_init) return;
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
    _init = true;
  }

  Future<RiskResponse?> getLast() async {
    await _ensure();
    final box = Hive.box<String>(_boxName);
    final raw = box.get('last');
    if (raw == null) return null;
    return RiskResponse.fromJson(jsonDecode(raw));
  }

  Future<void> saveLast(RiskResponse resp) async {
    await _ensure();
    final box = Hive.box<String>(_boxName);
    final map = {
      "location": {"name": resp.locationName},
      "climatology": {
        "rainProb": resp.rainProbClimo,
        "p50IntensityMmHr": resp.p50Intensity,
        "p90IntensityMmHr": resp.p90Intensity
      },
      "forecast": {
        "available": resp.rainProbForecast != null,
        "rainProb": resp.rainProbForecast
      },
      "cloudiness": resp.cloudiness,
      "heatRisk": resp.heatRisk,
      "readinessIndex": resp.readinessIndex,
      "rationale": resp.rationale
    };
    box.put('last', jsonEncode(map));
  }
}
