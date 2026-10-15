import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState extends ChangeNotifier {
  bool _isDark = true;
  bool _userChangedTheme = false;

  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    if (!_userChangedTheme) {
      _isDark = preferences.getBool('is_dark_theme') ?? true;
      notifyListeners();
    }
  }

  Future<void> setDark(bool value) async {
    if (_isDark == value) return;
    final previous = _isDark;
    _isDark = value;
    _userChangedTheme = true;
    notifyListeners();
    try {
      final preferences = await SharedPreferences.getInstance();
      if (!await preferences.setBool('is_dark_theme', value)) {
        throw StateError('Tema tercihi kaydedilemedi.');
      }
    } catch (_) {
      _isDark = previous;
      notifyListeners();
      rethrow;
    }
  }
}
