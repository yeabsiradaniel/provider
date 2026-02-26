import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/main.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderSettingsScreen extends ConsumerStatefulWidget {
  const ProviderSettingsScreen({Key? key}) : super(key: key);

  @override
  _ProviderSettingsScreenState createState() => _ProviderSettingsScreenState();
}

class _ProviderSettingsScreenState extends ConsumerState<ProviderSettingsScreen> {
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
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(l10n.settings),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                children: [
                   _buildSectionHeader('General', theme),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.5)),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsRow(
                          title: l10n.darkMode,
                          value: themeMode == ThemeMode.dark,
                          onChanged: _updateDarkMode,
                        ),
                        _buildDivider(theme),
                        _buildSettingsRow(
                          title: l10n.enableNotifications,
                          value: _notificationsEnabled,
                          onChanged: _updateNotifications,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                   _buildSectionHeader('Language', theme),
                   const SizedBox(height: 8),
                    Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                       border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.5)),
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
                         _buildDivider(theme),
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

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
        child: Text(
          title.toUpperCase(),
           style: theme.textTheme.labelSmall,
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Divider(height: 1, color: theme.colorScheme.tertiary.withOpacity(0.5)),
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
      ),
    );
  }

   Widget _buildLanguageRow({
    required String language,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
       contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Text(language, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: isSelected
          ? Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: theme.colorScheme.onPrimary, size: 16),
            )
          : null,
      onTap: onTap,
    );
  }
}
