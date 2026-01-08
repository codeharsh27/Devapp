import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. Theme Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const _themeKey = 'theme_mode';

  ThemeNotifier({ThemeMode? initialMode})
      : super(initialMode ?? ThemeMode.dark) {
    if (initialMode == null) {
      _loadTheme();
    }
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isLight = prefs.getBool(_themeKey) ?? false;
    state = isLight ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, mode == ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, state == ThemeMode.light);
  }
}

// 2. App Theme Definitions
class AppTheme {
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF09090B);
  static const Color darkSurface = Color(0xFF131316);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Colors.white54;

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF4F4F5);
  static const Color lightTextPrimary = Color(0xFF09090B);
  static const Color lightTextSecondary = Color(0xFF71717A);

  static const Color primaryColor = Color(0xFF4F46E5);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryColor,
      cardColor: darkSurface,
      dividerColor: Colors.white12,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: darkTextPrimary,
        displayColor: darkTextPrimary,
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        surface: darkSurface,
        background: darkBackground,
        secondary: primaryColor,
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: primaryColor,
      cardColor: lightSurface,
      dividerColor: Colors.black12,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: lightTextPrimary),
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: lightTextPrimary,
        displayColor: lightTextPrimary,
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        surface: lightSurface,
        background: lightBackground,
        secondary: primaryColor,
      ),
      iconTheme: const IconThemeData(color: Colors.black54),
    );
  }
}
