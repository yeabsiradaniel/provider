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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send booking request: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String providerName = widget.jobDetails['providerName'] ?? 'N/A';
    final String serviceName = widget.jobDetails['serviceName'] ?? 'N/A';
    final String description = widget.jobDetails['description'] ?? 'N/A';
    final String startDate = widget.jobDetails['startDate']?.split('T')[0] ?? 'N/A';
    final String endDate = widget.jobDetails['endDate']?.split('T')[0] ?? 'N/A';
    final String profilePhoto = widget.jobDetails['profilePhoto'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.confirmBooking),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Summary', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // Provider Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ProfileAvatar(imageUrl: profilePhoto, radius: 25),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Provider', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(providerName, style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Service Details Card
            _buildInfoCard(
              context: context,
              icon: Icons.work_outline,
              title: 'Service',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(serviceName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Date & Time Card
            _buildInfoCard(
              context: context,
              icon: Icons.calendar_today_outlined,
              title: 'Dates',
              child: Text('$startDate to $endDate', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l10n.cancel),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isBooking ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isBooking
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : Text(l10n.confirmBooking),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required BuildContext context, required IconData icon, required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
