import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/bookings/domain/providers/booking_provider.dart';
import 'package:mobile/features/client_dashboard/presentation/screens/client_home_screen.dart';
import 'package:mobile/features/provider_earnings/domain/providers/provider_earnings_provider.dart';
import 'package:mobile/features/review/domain/services/review_service.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'dart:developer';

class RatingScreen extends ConsumerStatefulWidget {
  final String jobId;
  final String providerId;

  const RatingScreen({Key? key, required this.jobId, required this.providerId})
      : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewService = ReviewService();
  final _paymentController = TextEditingController();
  double _rating = 4.0;
  bool _isSubmitting = false;

  Future<void> _submitReviewAndPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final paidAmount = double.tryParse(_paymentController.text);
      if (paidAmount == null) {
        throw Exception("Invalid payment amount");
      }

      await _reviewService.submitReview(
        jobId: widget.jobId,
        providerId: widget.providerId,
        rating: _rating,
        paidAmount: paidAmount,
      );

      log('Review and payment submitted for job ${widget.jobId}');

      ref.refresh(customerBookingsProvider);
      ref.refresh(providerEarningsProvider);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ClientHomeScreen()),
          (Route<dynamic> route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.thankYouForPaymentAndFeedback)),
        );
      }
    } catch (e) {
      log('Error submitting review: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.failedToSubmitReview}$e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _paymentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rateAndPay),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                l10n.howWasYourService,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: theme.colorScheme.primary),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              ),
              const SizedBox(height: 48),
              Text(
                l10n.amountPaid.toUpperCase(),
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _paymentController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  hintText: l10n.amountHint,                  prefixText: 'ETB ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterAmount;
                  }
                  if (double.tryParse(value) == null) {
                    return l10n.pleaseEnterValidNumber;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReviewAndPayment,
          child: _isSubmitting
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              : Text(l10n.submitPaymentAndReview),
        ),
      ),
    );
  }
}
