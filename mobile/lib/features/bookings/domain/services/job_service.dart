import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobService {
  final String _baseUrl = 'http://10.0.2.2:3001/api';

  Future<List<Job>> getBookingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/jobs/client'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load booking history');
    }
  }

  Future<void> createJob(Map<String, dynamic> jobDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/jobs'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(jobDetails),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create job');
    }
  }

  Future<void> acceptJob(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/jobs/$jobId/accept'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to accept job');
    }
  }

  Future<void> finishJob(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/jobs/$jobId/finish'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to finish job');
    }
  }
}
