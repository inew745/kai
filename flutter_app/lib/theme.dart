import 'package:flutter/material.dart';

class KaiTheme {
  static const Color bg = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF141414);
  static const Color surface2 = Color(0xFF1A1A1A);
  static const Color card = Color(0xFF1E1E2E);
  static const Color border = Color(0xFF222222);
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color textPrimary = Color(0xFFE8E8E8);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF4A4A4A);
  static const Color online = Color(0xFF34D399);
  static const Color error = Color(0xFFF87171);

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primaryDark,
        surface: surface,
        background: bg,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: primary,
        unselectedLabelColor: textSecondary,
        indicatorColor: primary,
      ),
      fontFamily: 'Roboto',
    );
  }
}
