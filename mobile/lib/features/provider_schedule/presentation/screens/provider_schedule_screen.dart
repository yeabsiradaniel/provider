import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/bookings/domain/services/job_service.dart';
import 'package:mobile/features/provider_schedule/domain/providers/provider_schedule_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'dart:developer';

class ProviderScheduleScreen extends ConsumerStatefulWidget {
  const ProviderScheduleScreen({Key? key}) : super(key: key);

  @override
  _ProviderScheduleScreenState createState() => _ProviderScheduleScreenState();
}

class _ProviderScheduleScreenState extends ConsumerState<ProviderScheduleScreen> {
  final JobService _jobService = JobService();
  late final ValueNotifier<List<Job>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Job> _getEventsForDay(DateTime day, List<Job> allJobs) {
    return allJobs.where((job) => job.startDate != null && isSameDay(job.startDate!, day)).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay, List<Job> allJobs) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay, allJobs);
      });
    }
  }

  Future<void> _finishJob(String jobId) async {
    try {
      await _jobService.finishJob(jobId);
      log('Job $jobId finished');
      ref.refresh(providerScheduleProvider);
    } catch (e) {
      log('Error finishing job: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to finish job: $e')),
      );
    }
  }

  void _showJobDetailsDialog(Job job) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(job.serviceName),
          content: Text("Status: ${job.status}\nDescription: ${job.description ?? ''}"),
          actions: [
            if (job.status == 'ACCEPTED' || job.status == 'ACTIVE')
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _finishJob(job.id);
                },
                child: const Text('Mark as Finished'),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheduleAsyncValue = ref.watch(providerScheduleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.schedule),
      ),
      body: scheduleAsyncValue.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (err, stack) {
          return Center(child: Text('Error: $err'));
        },
        data: (jobs) {
          final events = LinkedHashMap<DateTime, List<Job>>(
            equals: isSameDay,
            hashCode: getHashCode,
          )..addAll({
            for (var job in jobs.where((job) => job.startDate != null)) // Filter jobs without start date
              DateTime.utc(job.startDate!.year, job.startDate!.month, job.startDate!.day):
                  _getEventsForDay(job.startDate!, jobs)
          });
          
          // Update selected events for the first build
          WidgetsBinding.instance.addPostFrameCallback((_) {
             if(mounted) {
               _selectedEvents.value = _getEventsForDay(_selectedDay!, jobs);
             }
          });

          return SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar<Job>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  eventLoader: (day) => _getEventsForDay(day, jobs),
                  onDaySelected: (selected, focused) => _onDaySelected(selected, focused, jobs),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                              '${job.clientId?.firstName.substring(0, 1) ?? '?'}${job.clientId?.lastName.substring(0, 1) ?? ''}'),
                        ),
                        title: Text(job.serviceName),
                        subtitle: Text(DateFormat.jm().format(job.createdAt)),
                        trailing: Icon(
                          job.status == 'COMPLETED'
                              ? Icons.check_circle
                              : job.status == 'PENDING'
                                  ? Icons.pending
                                  : Icons.arrow_forward_ios,
                          color: job.status == 'COMPLETED'
                              ? Colors.green
                              : job.status == 'PENDING'
                                  ? Colors.orange
                                  : null,
                        ),
                        onTap: () => _showJobDetailsDialog(job),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
