import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/screens/registration_screen.dart';
import 'package:mobile/features/client_dashboard/presentation/screens/client_home_screen.dart';
import 'package:mobile/features/provider_dashboard/presentation/screens/provider_dashboard_screen.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:mobile/features/provider_profile/domain/providers/provider_profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckScreen extends ConsumerStatefulWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends ConsumerState<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
      );
      return;
    }

    await ref.read(userProvider.notifier).fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(userProvider, (_, state) {
      state.when(
        data: (user) {
          if (user != null) {
            if (user.role == 'client') {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ClientHomeScreen()),
              );
            } else if (user.role == 'provider') {
              ref.read(providerProfileProvider(user.id).notifier);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ProviderDashboardScreen()),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const RegistrationScreen()),
              );
            }
          }
        },
        loading: () {},
        error: (err, stack) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RegistrationScreen()),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
