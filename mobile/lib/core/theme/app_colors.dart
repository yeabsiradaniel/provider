import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // --- Core Palette ---
  static const Color primary = Color(0xFF000000);
  static const Color primaryInverse = Color(0xFFFFFFFF);
  
  static const Color secondary = Color(0xFF64748B); // A neutral, secondary text color
  static const Color tertiary = Color(0xFF94A3B8); // A lighter grey for borders, dividers

  // --- Backgrounds ---
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF0F172A); // A deep, dark blue
  
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B); // A slightly lighter dark blue for cards

  // --- System & Accents ---
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFACC15);
  static const Color error = Color(0xFFEF4444);
}
