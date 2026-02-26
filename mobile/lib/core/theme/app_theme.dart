import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/radius.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    scaffold: AppColors.background,
    primary: AppColors.primary,
    onPrimary: AppColors.primaryInverse,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    onSurface: AppColors.primary,
    tertiary: AppColors.tertiary,
  );

  static final ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    scaffold: AppColors.backgroundDark,
    primary: AppColors.primaryInverse,
    onPrimary: AppColors.primary,
    secondary: AppColors.tertiary, // Lighter grey for dark mode secondary text
    surface: AppColors.surfaceDark,
    onSurface: AppColors.primaryInverse,
    tertiary: AppColors.secondary, // Darker grey for dark mode tertiary
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color scaffold,
    required Color primary,
    required Color onPrimary,
    required Color secondary,
    required Color surface,
    required Color onSurface,
    required Color tertiary,
  }) {
    return ThemeData(
      brightness: brightness,
      primaryColor: primary,
      scaffoldBackgroundColor: scaffold,
      fontFamily: 'Plus Jakarta Sans',
      
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSurface,
        error: AppColors.error,
        onError: AppColors.primaryInverse,
        background: scaffold,
        onBackground: onSurface,
        surface: surface,
        onSurface: onSurface,
        tertiary: tertiary,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scaffold,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: AppRadius.textFieldRadius,
          borderSide: BorderSide(color: tertiary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.textFieldRadius,
          borderSide: BorderSide(color: tertiary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.textFieldRadius,
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        labelStyle: TextStyle(color: secondary),
        hintStyle: TextStyle(color: tertiary),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          disabledBackgroundColor: tertiary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Plus Jakarta Sans',
          )
        )
      ),

      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(AppColors.primaryInverse),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return tertiary;
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
           if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return null; // Defer to shape
        }),
        checkColor: MaterialStateProperty.all(onPrimary),
        side: BorderSide(color: tertiary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      )
    );
  }
}
