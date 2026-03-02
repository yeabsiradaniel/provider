import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/services/socket_service.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/screens/auth_check_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('darkMode') ?? false;
  final initialTheme = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  final languageCode = prefs.getString('selectedLanguage') ?? 'en';
  final initialLocale = Locale(languageCode);

  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => initialTheme),
        localeProvider.overrideWith((ref) => initialLocale),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the navigatorKey from its provider.
    final navigatorKey = ref.watch(navigatorKeyProvider);
    
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Service Link',
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme, // Define your light theme
      darkTheme: AppTheme.darkTheme, // Define your dark theme
      themeMode: themeMode,
      // Use a Builder to ensure we have a clean startup sequence.
      home: Builder(
        builder: (context) {
          // Return the first screen of the app.
          return const AuthCheckScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
