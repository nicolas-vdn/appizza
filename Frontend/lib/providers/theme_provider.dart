import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    initialTheme();
  }

  void setThemeMode(bool dark) {
    _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
  }

  void initialTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isDark = prefs.getBool('themeDark');

    if (isDark != null) {
      setThemeMode(isDark);
    }

    notifyListeners();
  }

  Future<void> switchThemeMode(BuildContext context) async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final prefs = await SharedPreferences.getInstance();

    setThemeMode(!isDark);
    await prefs.setBool('themeDark', !isDark);

    notifyListeners();
  }
}
