import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/bookings/domain/services/job_service.dart';

final jobServiceProvider = Provider((ref) => JobService());

final customerBookingsProvider = FutureProvider<List<Job>>((ref) async {
  final jobService = ref.watch(jobServiceProvider);
  return jobService.getBookingHistory();
});
