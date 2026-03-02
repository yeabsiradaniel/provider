import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/bookings/domain/providers/booking_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    var status = await Permission.phone.status;
    if (status.isGranted) {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'Could not launch $phoneUri';
      }
    } else {
      if (await Permission.phone.request().isGranted) {
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          throw 'Could not launch $phoneUri';
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(customerBookingsProvider, (previous, next) {
      if (next is AsyncData) {
        print('Bookings provider has new data.');
      }
    });

    final l10n = AppLocalizations.of(context)!;
    final bookingsAsyncValue = ref.watch(customerBookingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: bookingsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${l10n.errorPrefix}$err')),
        data: (jobs) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(customerBookingsProvider.future),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  title: Text(l10n.bookings),
                ),
                if (jobs.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        l10n.bookingWillAppearHere,
                        style: TextStyle(color: theme.colorScheme.secondary),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final job = jobs[index];
                          return _buildBookingItem(context, job, ref);
                        },
                        childCount: jobs.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingItem(BuildContext context, Job job, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    final providerName = (job.providerId != null) 
        ? '${job.providerId!.firstName} ${job.providerId!.lastName}'
        : 'Provider N/A';
    
    Color statusColor;
    String statusText;
    bool isPrimaryStatus;

    switch (job.status) {
      case 'COMPLETED':
        statusColor = theme.colorScheme.primary;
        statusText = l10n.completed;
        isPrimaryStatus = true;
        break;
      case 'CANCELLED':
        statusColor = theme.colorScheme.tertiary;
        statusText = l10n.cancelled;
        isPrimaryStatus = false;
        break;
      case 'ACCEPTED':
         statusColor = theme.colorScheme.primary;
         statusText = l10n.upcoming;
         isPrimaryStatus = true;
         break;
      default:
        statusColor = theme.colorScheme.secondary;
        statusText = l10n.upcoming;
        isPrimaryStatus = false;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.serviceName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  providerName,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: theme.colorScheme.secondary),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat.yMMMd().format(job.createdAt),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (job.status == 'ACCEPTED' && job.providerId?.phone != null)
                  const SizedBox(height: 8),
                if (job.status == 'ACCEPTED' && job.providerId?.phone != null)
                  InkWell(
                    onTap: () => _launchPhone(job.providerId!.phone),
                    child: Row(
                      children: [
                        Icon(Icons.phone, size: 12, color: theme.colorScheme.secondary),
                        const SizedBox(width: 4),
                        Text(
                          job.providerId!.phone,
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isPrimaryStatus ? statusColor : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isPrimaryStatus ? null : Border.all(color: statusColor),
            ),
            child: Text(
              statusText.toUpperCase(),
              style: TextStyle(
                color: isPrimaryStatus ? theme.colorScheme.onPrimary : statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
