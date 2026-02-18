import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer';
import 'package:mobile/core/widgets/profile_avatar.dart';
import 'package:mobile/features/auth/presentation/screens/registration_screen.dart';
import 'package:mobile/features/provider_profile/presentation/screens/availability_settings_screen.dart';
import 'package:mobile/features/provider_profile/presentation/screens/edit_provider_profile_screen.dart';
import 'package:mobile/features/provider_profile/presentation/screens/service_history_screen.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderProfileScreen extends ConsumerWidget {
  const ProviderProfileScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    log('===== PROVIDER LOGOUT START =====');
    try {
      log('[Logout] 1. Clearing user from userProvider...');
      ref.read(userProvider.notifier).clearUser();
      log('[Logout] 2. User cleared.');

      log('[Logout] 3. Clearing SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      log('[Logout] 4. SharedPreferences cleared.');

      log('[Logout] 5. Navigating to RegistrationScreen...');
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const RegistrationScreen()),
          (Route<dynamic> route) => false,
        );
      }
      log('[Logout] 6. Navigation complete.');
    } catch (e, stack) {
      log('[Logout] ERROR during logout process!', error: e, stackTrace: stack);
    }
    log('===== PROVIDER LOGOUT END =====');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userAsyncValue = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
      ),
      body: userAsyncValue.when(
        data: (user) {
          if (user == null) {
            return Center(child: Text(l10n.genericError));
          }
          return ListView(
            children: [
              const SizedBox(height: 24),
              ProfileAvatar(
                imageUrl: user.profilePhoto ?? '',
                radius: 50,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildProfileMenuItem(
                context,
                icon: Icons.person_outline,
                text: l10n.editProfile,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProviderProfileScreen()),
                  );
                },
              ),
              _buildProfileMenuItem(
                context,
                icon: Icons.miscellaneous_services_outlined,
                text: l10n.availabilitySettings,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AvailabilitySettingsScreen(),
                    ),
                  );
                },
              ),
              _buildProfileMenuItem(
                context,
                icon: Icons.history_outlined,
                text: l10n.serviceHistory,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceHistoryScreen(),
                    ),
                  );
                },
              ),
              _buildProfileMenuItem(
                context,
                icon: Icons.logout_outlined,
                text: l10n.logout,
                onTap: () => _logout(context, ref),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
      ),
    );
  }

  Widget _buildProfileMenuItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
