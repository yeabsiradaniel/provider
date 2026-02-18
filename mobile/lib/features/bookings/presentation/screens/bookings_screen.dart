import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/bookings/domain/providers/booking_provider.dart';
import 'package:mobile/features/review/presentation/screens/rating_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bookingsAsyncValue = ref.watch(customerBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bookings),
      ),
      body: bookingsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (jobs) {
          if (jobs.isEmpty) {
            return Center(
              child: Text(l10n.bookingWillAppearHere),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(customerBookingsProvider.future),
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return _buildBookingItem(context, job, ref);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingItem(BuildContext context, Job job, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // The providerId field is now a User object.
    final providerName = (job.providerId != null) 
        ? '${job.providerId!.firstName} ${job.providerId!.lastName}'
        : 'Provider N/A';
    
    Color statusColor;
    String statusText;
    bool showRateButton = false;
    switch (job.status) {
      case 'COMPLETED':
        statusColor = Colors.green;
        statusText = l10n.completed;
        showRateButton = true; 
        break;
      case 'CANCELLED':
        statusColor = Colors.red;
        statusText = l10n.cancelled;
        break;
      case 'ACCEPTED':
         statusColor = Colors.blue;
         statusText = l10n.upcoming; // Or some other status
         break;
      default:
        statusColor = Colors.orange;
        statusText = l10n.upcoming;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bolt,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.serviceName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        providerName,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat.yMMMd().format(job.createdAt),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if(showRateButton && job.providerId != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingScreen(jobId: job.id, providerId: job.providerId!.id),
                      ),
                    );
                    ref.refresh(customerBookingsProvider);
                  },
                  child: Text(l10n.rateProvider),
                ),
              )
          ],
        ),
      ),
    );
  }
}
