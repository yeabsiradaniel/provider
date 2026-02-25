import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/screens/registration_screen.dart';
import 'package:mobile/features/bookings/domain/providers/unrated_job_provider.dart';
import 'package:mobile/features/client_dashboard/presentation/screens/client_home_screen.dart';
import 'package:mobile/features/provider_dashboard/presentation/screens/provider_dashboard_screen.dart';
import 'package:mobile/features/review/presentation/screens/rating_screen.dart';
import 'package:mobile/features/user/domain/models/user.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This screen acts as a router that runs when the app starts.
/// It's responsible for checking authentication status and then determining
/// the correct screen to show the user, handling the mandatory rating logic.
class AuthCheckScreen extends ConsumerStatefulWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends ConsumerState<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    // Attempt to load the user from token on initial startup.
    _loadUserFromToken();
  }

  Future<void> _loadUserFromToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      // Fetch user data if a token exists. The provider's state change
      // will be picked up by the build method.
      await ref.read(userProvider.notifier).fetchUser();
    } else {
      // If no token, force a state change to navigate to registration
      ref.read(userProvider.notifier).clearUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          // No authenticated user, show registration screen.
          return const RegistrationScreen();
        }
        
        // If the user is a provider, send them to their dashboard.
        if (user.role == 'provider') {
          return const ProviderDashboardScreen();
        }

        // If the user is a client, we must check for unrated jobs.
        if (user.role == 'client') {
          return const _UnratedJobCheck();
        }

        // Fallback to registration if role is unknown
        return const RegistrationScreen();
      },
      // Show a loading spinner while checking for a token and fetching user.
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      // If fetching user fails (e.g., bad token), send to registration.
      error: (err, stack) => const RegistrationScreen(),
    );
  }
}

/// An internal widget that handles the second step of the auth flow for clients:
/// checking for an unrated job.
class _UnratedJobCheck extends ConsumerWidget {
  const _UnratedJobCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unratedJobAsync = ref.watch(unratedJobCheckProvider);

    return unratedJobAsync.when(
      data: (unratedJob) {
        if (unratedJob != null && unratedJob.providerId != null) {
          // An unrated job was found, so we MUST show the rating screen.
          return RatingScreen(
            jobId: unratedJob.id,
            providerId: unratedJob.providerId!.id,
          );
        } else {
          // No unrated jobs, proceed to the client's normal home screen.
          return const ClientHomeScreen();
        }
      },
      // Show a loading spinner while we check for unrated jobs.
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      // If the check fails, send them to the home screen as a fallback.
      // This prevents them from being stuck on a broken auth flow.
      error: (err, stack) => const ClientHomeScreen(),
    );
  }
}
