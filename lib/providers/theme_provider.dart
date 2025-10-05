import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _settingsBox = 'settings';
const _themeKey = 'themeMode'; // 'light' | 'dark' | 'system'

final themeModeProvider =
StateNotifierProvider<ThemeController, ThemeMode>((ref) {
  final ctrl = ThemeController();
  ctrl.load(); // fire and forget
  return ctrl;
});

class ThemeController extends StateNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.system);

  Future<void> load() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>(_settingsBox);
    final raw = box.get(_themeKey, defaultValue: 'system');
    state = _decode(raw ?? 'system');
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final box = await Hive.openBox<String>(_settingsBox);
    await box.put(_themeKey, _encode(mode));
  }

  String _encode(ThemeMode m) {
    switch (m) {
      case ThemeMode.light: return 'light';
      case ThemeMode.dark:  return 'dark';
      case ThemeMode.system:
      default:              return 'system';
    }
  }

  ThemeMode _decode(String s) {
    switch (s) {
      case 'light': return ThemeMode.light;
      case 'dark':  return ThemeMode.dark;
      default:      return ThemeMode.system;
    }
  }
}
