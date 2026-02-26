import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
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
      final status = await Permission.notification.request();
      if (status.isGranted) {
        await prefs.setBool('notificationsEnabled', true);
        setState(() {
          _notificationsEnabled = true;
        });
      } else {
        await prefs.setBool('notificationsEnabled', false);
        setState(() {
          _notificationsEnabled = false;
        });
      }
    } else {
      await prefs.setBool('notificationsEnabled', false);
      setState(() {
        _notificationsEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0.5,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              l10n.settings,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                children: [
                   _buildSectionHeader('General'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsRow(
                          title: l10n.darkMode,
                          value: themeMode == ThemeMode.dark,
                          onChanged: _updateDarkMode,
                        ),
                        _buildDivider(),
                        _buildSettingsRow(
                          title: l10n.enableNotifications,
                          value: _notificationsEnabled,
                          onChanged: _updateNotifications,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                   _buildSectionHeader('Language'),
                   const SizedBox(height: 8),
                    Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                       border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildLanguageRow(
                          language: 'English',
                          isSelected: locale.languageCode == 'en',
                          onTap: () async {
                            await _updateLanguage('en');
                          },
                        ),
                         _buildDivider(),
                         _buildLanguageRow(
                          language: 'አማርኛ',
                          isSelected: locale.languageCode == 'am',
                          onTap: () async {
                             await _updateLanguage('am');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _updateLanguage(String newLang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', newLang);
    ref.read(localeProvider.notifier).state = Locale(newLang);
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
        child: Text(
          title.toUpperCase(),
           style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 0.8,
            ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }

  Widget _buildSettingsRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: Colors.black,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey.shade300,
      ),
    );
  }

   Widget _buildLanguageRow({
    required String language,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
       contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Text(language, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: isSelected
          ? Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            )
          : null,
      onTap: onTap,
    );
  }
}
