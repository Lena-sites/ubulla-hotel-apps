import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  // Mengambil tema yang tersimpan
  static Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool('isDarkMode') ?? false;

    themeNotifier.value =
    isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // Mengubah dan menyimpan tema
  static Future<void> setTheme(ThemeMode mode) async {
    themeNotifier.value = mode;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'isDarkMode',
      mode == ThemeMode.dark,
    );
  }
}