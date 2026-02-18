import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/provider_schedule/domain/services/provider_schedule_service.dart';

final providerScheduleServiceProvider = Provider((ref) => ProviderScheduleService());

final providerScheduleProvider = FutureProvider<List<Job>>((ref) async {
  final scheduleService = ref.watch(providerScheduleServiceProvider);
  return scheduleService.getProviderSchedule();
});
