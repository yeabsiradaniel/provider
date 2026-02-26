import 'package:flutter/material.dart';
import 'package:mobile/core/theme/radius.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF000000),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF000000),
      secondary: Color(0xFF808080),
      background: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF000000),
      onBackground: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      tertiary: Color(0xFF808080), // for label-caps
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
        color: Color(0xFF808080),
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

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFFFFFFF),
    scaffoldBackgroundColor: const Color(0xFF000000),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFFFFFF),
      secondary: Color(0xFF808080),
      background: Color(0xFF000000),
      surface: Color(0xFF000000),
      onPrimary: Color(0xFF000000),
      onSecondary: Color(0xFFFFFFFF),
      onBackground: Color(0xFFFFFFFF),
      onSurface: Color(0xFFFFFFFF),
      tertiary: Color(0xFF808080), // for label-caps
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
        color: Color(0xFF808080),
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
