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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(providerScheduleProvider);
    });
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(job.serviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Status: ${job.status.toUpperCase()}\n\nDescription:\n${job.description ?? 'No description provided.'}"),
          actions: [
            if (job.status == 'ACCEPTED' || job.status == 'ACTIVE')
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _finishJob(job.id);
                },
                child: const Text('Mark as Finished', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.grey)),
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
      backgroundColor: Colors.grey.shade50,
      body: scheduleAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (jobs) {
          final events = LinkedHashMap<DateTime, List<Job>>(
            equals: isSameDay,
            hashCode: getHashCode,
          )..addAll({
            for (var job in jobs.where((job) => job.startDate != null))
              DateTime.utc(job.startDate!.year, job.startDate!.month, job.startDate!.day):
                  _getEventsForDay(job.startDate!, jobs)
          });
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
             if(mounted) {
               _selectedEvents.value = _getEventsForDay(_selectedDay!, jobs);
             }
          });

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                pinned: true,
                elevation: 0.5,
                title: Text(
                  l10n.schedule,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: TableCalendar<Job>(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: (day) => events[day] ?? [],
                    onDaySelected: (selected, focused) => _onDaySelected(selected, focused, jobs),
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                       markerDecoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ValueListenableBuilder<List<Job>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  if (value.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: Text('No appointments for this day.', style: TextStyle(color: Colors.grey.shade600)),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final job = value[index];
                           return _buildEventItem(job);
                        },
                        childCount: value.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEventItem(Job job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          child: Text(
            '${job.clientId?.firstName.substring(0, 1) ?? '?'}${job.clientId?.lastName.substring(0, 1) ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        title: Text(job.serviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat.jm().format(job.startDate ?? job.createdAt)),
        trailing: Icon(
          job.status == 'COMPLETED'
              ? Icons.check_circle
              : Icons.chevron_right,
          color: job.status == 'COMPLETED'
              ? Colors.black
              : Colors.grey.shade400,
        ),
        onTap: () => _showJobDetailsDialog(job),
      ),
    );
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
