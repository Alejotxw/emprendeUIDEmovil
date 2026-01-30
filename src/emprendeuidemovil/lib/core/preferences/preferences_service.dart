import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _darkModeKey = 'darkMode';
  static const _fontSizeKey = 'fontSize';

  // Guardar modo oscuro
  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  // Obtener modo oscuro
  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  // Guardar tamaño de letra
  Future<void> setFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }

  // Obtener tamaño de letra
  Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontSizeKey) ?? 14.0;
  }
}
