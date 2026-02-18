import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mobile/main.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // No local state for dark mode, it's now controlled by the provider
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load notification setting
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      // The theme is already loaded by main.dart before the app runs
    });
  }

  Future<void> _updateDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final newTheme = value ? ThemeMode.dark : ThemeMode.light;
    await prefs.setBool('darkMode', value);
    ref.read(themeProvider.notifier).state = newTheme;
  }

  Future<void> _updateNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value) {
      // Request permission when turning on
      final status = await Permission.notification.request();
      if (status.isGranted) {
        await prefs.setBool('notificationsEnabled', true);
        setState(() {
          _notificationsEnabled = true;
        });
      } else {
        // If permission is denied, keep the switch off
        await prefs.setBool('notificationsEnabled', false);
        setState(() {
          _notificationsEnabled = false;
        });
      }
    } else {
      // If turning off, just save the state
      await prefs.setBool('notificationsEnabled', false);
      setState(() {
        _notificationsEnabled = false;
      });
    }
  }

  Future<void> _updateLanguage(bool isAmharic) async {
    final prefs = await SharedPreferences.getInstance();
    final newLang = isAmharic ? 'am' : 'en';
    await prefs.setString('selectedLanguage', newLang);
    ref.read(localeProvider.notifier).state = Locale(newLang);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.darkMode),
            value: themeMode == ThemeMode.dark,
            onChanged: _updateDarkMode,
          ),
          SwitchListTile(
            title: Text(l10n.enableNotifications),
            value: _notificationsEnabled,
            onChanged: _updateNotifications,
          ),
          SwitchListTile(
            title: const Text('አማርኛ'),
            value: locale.languageCode == 'am',
            onChanged: _updateLanguage,
          ),
        ],
      ),
    );
  }
}
