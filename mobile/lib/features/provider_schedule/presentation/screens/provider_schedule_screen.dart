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
       final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.failedToFinishJob}$e')),
      );
    }
  }

  void _showJobDetailsDialog(Job job) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(job.serviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text("${l10n.status}: ${job.status.toUpperCase()}\n\n${l10n.description}:\n${job.description ?? l10n.noDescriptionProvided}"),
          actions: [
            if (job.status == 'ACCEPTED' || job.status == 'ACTIVE')
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _finishJob(job.id);
                },
                child: Text(l10n.markAsFinished, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close, style: TextStyle(color: theme.colorScheme.secondary)),
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
    final theme = Theme.of(context);

    return Scaffold(
      body: scheduleAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${l10n.errorPrefix}$err')),
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
                title: Text(l10n.schedule),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: theme.colorScheme.surface,
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
                      defaultTextStyle: TextStyle(color: theme.colorScheme.onSurface),
                      weekendTextStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      outsideTextStyle: TextStyle(color: theme.colorScheme.secondary.withOpacity(0.5)),
                      todayDecoration: BoxDecoration(
                        color: theme.colorScheme.tertiary.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                       markerDecoration: BoxDecoration(
                        color: theme.colorScheme.primary,
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
                          child: Text(l10n.noAppointmentsForThisDay, style: TextStyle(color: theme.colorScheme.secondary)),
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
                           return _buildEventItem(job, theme);
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

  Widget _buildEventItem(Job job, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.5)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.scaffoldBackgroundColor,
          child: Text(
            '${job.clientId?.firstName.substring(0, 1) ?? '?'}${job.clientId?.lastName.substring(0, 1) ?? ''}',
            style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          ),
        ),
        title: Text(job.serviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat.jm().format(job.startDate ?? job.createdAt)),
        trailing: Icon(
          job.status == 'COMPLETED'
              ? Icons.check_circle
              : Icons.chevron_right,
          color: job.status == 'COMPLETED'
              ? theme.colorScheme.primary
              : theme.colorScheme.tertiary,
        ),
        onTap: () => _showJobDetailsDialog(job),
      ),
    );
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
