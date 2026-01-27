import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _darkMode = false;
  bool _largeFont = false;

  bool get darkMode => _darkMode;
  bool get largeFont => _largeFont;

  SettingsProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool('pref_dark_mode') ?? false;
    _largeFont = prefs.getBool('pref_large_font') ?? false;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_dark_mode', value);
    notifyListeners();
  }

  Future<void> setLargeFont(bool value) async {
    _largeFont = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_large_font', value);
    notifyListeners();
  }
}
