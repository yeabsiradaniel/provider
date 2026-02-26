import 'package:flutter/material.dart';
import 'package:mobile/features/bookings/domain/services/job_service.dart';
import 'package:mobile/features/bookings/presentation/screens/booking_success_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/core/widgets/profile_avatar.dart';
import 'dart:developer';

class ConfirmBookingScreen extends StatefulWidget {
  final Map<String, dynamic> jobDetails;

  const ConfirmBookingScreen({Key? key, required this.jobDetails}) : super(key: key);

  @override
  _ConfirmBookingScreenState createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  final JobService _jobService = JobService();
  bool _isBooking = false;

  Future<void> _confirmBooking() async {
    setState(() {
      _isBooking = true;
    });

    try {
      await _jobService.createJob(widget.jobDetails);
      
      log("Booking confirmed for: ${widget.jobDetails}");
      
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const BookingSuccessScreen()),
        (route) => route.isFirst,
      );

    } catch (e) {
      log("Error confirming booking: $e");
      setState(() {
        _isBooking = false;
      });
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.failedToSendBookingRequest}$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final String providerName = widget.jobDetails['providerName'] ?? 'N/A';
    final String serviceName = widget.jobDetails['serviceName'] ?? 'N/A';
    final String description = widget.jobDetails['description'] ?? 'N/A';
    final String startDate = widget.jobDetails['startDate']?.split('T')[0] ?? 'N/A';
    final String endDate = widget.jobDetails['endDate']?.split('T')[0] ?? 'N/A';
    final String profilePhoto = widget.jobDetails['profilePhoto'] ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(l10n.confirmBooking),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.summary, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _buildSectionHeader(l10n.provider, theme),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.5))
                    ),
                    child: Row(
                      children: [
                        ProfileAvatar(imageUrl: profilePhoto, radius: 24),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(providerName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader(l10n.services, theme),
                  const SizedBox(height: 12),
                  _buildInfoRow(icon: Icons.work_outline, text: serviceName, theme: theme),
                  const SizedBox(height: 8),
                   Padding(
                     padding: const EdgeInsets.only(left: 36.0),
                     child: Text(description, style: TextStyle(color: theme.colorScheme.secondary, fontSize: 14)),
                   ),
                  const SizedBox(height: 24),
                  _buildSectionHeader(l10n.dates, theme),
                  const SizedBox(height: 12),
                  _buildInfoRow(icon: Icons.calendar_today_outlined, text: '$startDate to $endDate', theme: theme),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.colorScheme.tertiary.withOpacity(0.5)))
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: theme.colorScheme.tertiary)
                ),
                child: Text(l10n.cancel, style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isBooking ? null : _confirmBooking,
                child: _isBooking
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      )
                    : Text(l10n.confirmBooking),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Text(
      title.toUpperCase(),
      style: theme.textTheme.labelSmall,
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text, required ThemeData theme}) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.onSurface, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
