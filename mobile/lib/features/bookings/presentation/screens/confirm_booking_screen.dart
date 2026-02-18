import 'package:flutter/material.dart';
import 'package:mobile/features/bookings/domain/services/job_service.dart';
import 'package:mobile/features/bookings/presentation/screens/booking_success_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.confirmBooking),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Summary', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Provider: ${widget.jobDetails['providerName']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                     Text('Service: ${widget.jobDetails['serviceName']}'),
                    const SizedBox(height: 8),
                    Text('Description: ${widget.jobDetails['description']}'),
                    const SizedBox(height: 8),
                    Text('Dates: ${widget.jobDetails['startDate'].split('T')[0]} to ${widget.jobDetails['endDate'].split('T')[0]}'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isBooking ? null : _confirmBooking,
                    child: _isBooking 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : Text(l10n.confirmBooking),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
