import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/widgets/profile_avatar.dart';
import 'package:mobile/features/auth/presentation/screens/registration_screen.dart';
import 'package:mobile/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:mobile/features/profile/presentation/screens/settings_screen.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    // Clear the provider state
    ref.read(userProvider.notifier).clearUser();
    
    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to registration screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const RegistrationScreen()),
      (Route<dynamic> route) => false,
    );
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
            return const Center(child: Text('Not logged in.'));
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
                onTap: () async {
                  // Navigate and wait for a potential update
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfileScreen()),
                  );
                  // No need to manually refetch, EditProfileScreen will update the provider
                },
              ),
              _buildProfileMenuItem(
                context,
                icon: Icons.settings_outlined,
                text: l10n.settings,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
              ),
              _buildProfileMenuItem(
                context,
                icon: Icons.payment_outlined,
                text: l10n.paymentMethods,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.comingSoon)),
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
        error: (err, stack) => const Center(child: Text('Error loading profile.')),
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
