import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile/features/review/domain/services/review_service.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'dart:developer';

class RatingScreen extends StatefulWidget {
  final String jobId;
  final String providerId;

  const RatingScreen({Key? key, required this.jobId, required this.providerId}) : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final ReviewService _reviewService = ReviewService();
  final _reviewController = TextEditingController();
  double _rating = 3.0;
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await _reviewService.submitReview(
        jobId: widget.jobId,
        providerId: widget.providerId,
        rating: _rating,
        comment: _reviewController.text,
      );
      
      log('Review submitted for job ${widget.jobId}');
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );

    } catch (e) {
      log('Error submitting review: $e');
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rateProvider),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.addAComment,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              child: _isSubmitting 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(l10n.submitReview),
            ),
          ],
        ),
      ),
    );
  }
}
