import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    setTheme();
  }

  Future<void> switchThemeMode(BuildContext context) async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('themeDark', !isDark);

    notifyListeners();
  }

  setTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isDark = prefs.getBool('themeDark');
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    notifyListeners();
  }
}
