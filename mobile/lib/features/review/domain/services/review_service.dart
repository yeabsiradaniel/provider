import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  final String _baseUrl = 'http://10.0.2.2:3001/api';

  Future<void> submitReview({
    required String jobId,
    required String providerId,
    required double rating,
    required String comment,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/reviews'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'jobId': jobId,
        'providerId': providerId,
        'rating': rating,
        'comment': comment,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to submit review');
    }
  }
}
