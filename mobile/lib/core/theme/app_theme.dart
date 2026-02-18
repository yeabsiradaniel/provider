import 'package:flutter/material.dart';
import 'package:mobile/core/theme/radius.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF0056B3),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0056B3),
      secondary: Color(0xFFFFD700),
      background: Color(0xFFF8FAFC),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF1E293B),
      onBackground: Color(0xFF1E293B),
      onSurface: Color(0xFF1E293B),
      tertiary: Color(0xFF94A3B8), // for label-caps
    ),
    fontFamily: 'Plus Jakarta Sans',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02 * 26.0,
        fontFamilyFallback: ['Noto Sans Ethiopic', 'sans-serif'],
      ),
      headlineMedium: TextStyle(
        fontSize: 19.0,
        fontWeight: FontWeight.w700,
        fontFamilyFallback: ['Noto Sans Ethiopic', 'sans-serif'],
      ),
      labelSmall: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.12 * 10.0,
        color: Color(0xFF94A3B8),
        fontFamilyFallback: ['Noto Sans Ethiopic', 'sans-serif'],
      ),
    ),
    cardTheme: const CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardRadius,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
        ),
      ),
    ),
  );
}
