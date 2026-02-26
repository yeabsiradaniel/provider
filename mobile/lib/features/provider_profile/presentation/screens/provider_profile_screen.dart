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
    ref.read(userProvider.notifier).clearUser();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

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
      backgroundColor: Colors.grey.shade50,
      body: userAsyncValue.when(
        data: (user) {
          if (user == null) {
            return Center(child: Text(l10n.notLoggedIn));
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                pinned: true,
                elevation: 0.5,
                title: Text(
                  l10n.profile,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    ProfileAvatar(
                      imageUrl: user.profilePhoto ?? '',
                      radius: 50,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      user.role.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 40),
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
                      isDestructive: true,
                      onTap: () => _logout(context, ref),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(l10n.errorLoadingProfile)),
      ),
    );
  }

  Widget _buildProfileMenuItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(12),
           border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isDestructive ? Colors.red : Colors.black,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? Colors.red : Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
