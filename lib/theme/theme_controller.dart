import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple controller for ThemeMode with local persistence.
class ThemeController extends ChangeNotifier {
  static const _key = 'theme_mode';

  ThemeController();

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_key);
      if (value != null) {
        _mode = ThemeMode.values.firstWhere(
          (m) => describeEnum(m) == value,
          orElse: () => ThemeMode.system,
        );
        notifyListeners();
      }
    } catch (_) {
      // ignore failures, keep default
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, describeEnum(mode));
    } catch (_) {
      // ignore persistence error
    }
  }
}

