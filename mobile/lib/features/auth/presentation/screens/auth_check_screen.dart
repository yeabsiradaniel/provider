import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/screens/registration_screen.dart';
import 'package:mobile/features/bookings/domain/providers/unrated_job_provider.dart';
import 'package:mobile/features/client_dashboard/presentation/screens/client_home_screen.dart';
import 'package:mobile/features/provider_dashboard/presentation/screens/provider_dashboard_screen.dart';
import 'package:mobile/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mobile/features/review/presentation/screens/rating_screen.dart';
import 'package:mobile/features/splash/presentation/screens/splash_screen.dart';
import 'package:mobile/features/user/domain/models/user.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckScreen extends ConsumerStatefulWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends ConsumerState<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserFromToken();
  }

  Future<void> _loadUserFromToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      await ref.read(userProvider.notifier).fetchUser();
    } else {
      ref.read(userProvider.notifier).clearUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const _OnboardingCheck();
        }
        
        if (user.role == 'provider') {
          return const ProviderDashboardScreen();
        }

        if (user.role == 'client') {
          return const _UnratedJobCheck();
        }

        return const RegistrationScreen();
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => const RegistrationScreen(),
    );
  }
}

class _OnboardingCheck extends StatefulWidget {
  const _OnboardingCheck({Key? key}) : super(key: key);

  @override
  State<_OnboardingCheck> createState() => _OnboardingCheckState();
}

class _OnboardingCheckState extends State<_OnboardingCheck> {
  late Future<bool> _hasOnboardedFuture;

  @override
  void initState() {
    super.initState();
    _hasOnboardedFuture = _checkOnboardingStatus();
  }

  Future<bool> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasCompletedOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasOnboardedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While checking the flag, show the splash screen as it's part of the onboarding
          return const SplashScreen();
        } else if (snapshot.hasData && snapshot.data == true) {
          // User has onboarded, show registration
          return const RegistrationScreen();
        } else {
          // User has NOT onboarded, show the full onboarding flow
          return const OnboardingScreen(); 
        }
      },
    );
  }
}


class _UnratedJobCheck extends ConsumerWidget {
  const _UnratedJobCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unratedJobAsync = ref.watch(unratedJobCheckProvider);

    return unratedJobAsync.when(
      data: (unratedJob) {
        if (unratedJob != null && unratedJob.providerId != null) {
          return RatingScreen(
            jobId: unratedJob.id,
            providerId: unratedJob.providerId!.id,
          );
        } else {
          return const ClientHomeScreen();
        }
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => const ClientHomeScreen(),
    );
  }
}
