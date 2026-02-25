import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/bookings/domain/services/job_service.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';

/// A provider that performs the initial check for an unrated job for a client.
///
/// It depends on the [userProvider] to ensure a user is logged in. If the user
/// is a client, it calls the [JobService] to find the first available unrated job.
final unratedJobCheckProvider = FutureProvider<Job?>((ref) async {
  final userAsyncValue = ref.watch(userProvider);

  // Wait for the user to be fully loaded and authenticated.
  final user = userAsyncValue.value;

  if (user != null && user.role == 'client') {
    final jobService = JobService();
    // Fetch the unrated job. This will return a Job or null.
    final unratedJob = await jobService.getUnratedJobForClient();
    return unratedJob;
  }

  // Return null if there's no user, or the user is not a client.
  return null;
});
