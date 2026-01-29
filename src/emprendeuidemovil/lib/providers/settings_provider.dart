import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
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

  void setDarkMode(bool isDark) async {
    _darkMode = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_dark_mode', isDark);
    notifyListeners();
  }

  void setLargeFont(bool isLarge) async {
    _largeFont = isLarge;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_large_font', isLarge);
    notifyListeners();
  }
}
