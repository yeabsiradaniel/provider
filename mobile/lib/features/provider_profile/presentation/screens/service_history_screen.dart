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
      if (mounted) {
        setState(() {
          _jobs = jobs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
           SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0.5,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              l10n.serviceHistory,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          _isLoading
            ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            : _jobs.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Text(
                      l10n.bookingWillAppearHere,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  ),
                )
              : SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final job = _jobs[index];
                      return _buildHistoryItem(job);
                    },
                    childCount: _jobs.length
                  ),
                ),
              ),
        ],
      )
    );
  }

  Widget _buildHistoryItem(Job job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Icon(Icons.history, color: Colors.grey.shade600, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.serviceName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                 Text(
                  'Client: ${job.clientId?.firstName ?? 'Unknown'} ${job.clientId?.lastName ?? ''}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat.yMMMd().format(job.createdAt),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                '${job.agreedPrice} ETB',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          )
        ],
      ),
    );
  }
}
