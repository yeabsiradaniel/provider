import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/provider_schedule/domain/services/provider_schedule_service.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({Key? key}) : super(key: key);

  @override
  _ServiceHistoryScreenState createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  final ProviderScheduleService _scheduleService = ProviderScheduleService();
  List<Job> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServiceHistory();
  }

  Future<void> _fetchServiceHistory() async {
    try {
      final jobs = await _scheduleService.getProviderSchedule();
      setState(() {
        _jobs = jobs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.serviceHistory),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _jobs.isEmpty
              ? Center(
                  child: Text(l10n.bookingWillAppearHere),
                )
              : ListView.builder(
                  itemCount: _jobs.length,
                  itemBuilder: (context, index) {
                    final job = _jobs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(job.serviceName),
                        subtitle: Text(
                            'Client: ${job.clientId?.firstName ?? 'Unknown'} ${job.clientId?.lastName ?? 'Client'}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(DateFormat.yMMMd().format(job.createdAt)),
                            Text(
                              '${job.agreedPrice} ETB',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
