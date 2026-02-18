import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/provider_dashboard/domain/models/dashboard_metrics.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/provider_profile/domain/models/provider_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  final String _baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator localhost

  Future<DashboardMetrics> getDashboardMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/provider/me/dashboard'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return DashboardMetrics.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dashboard metrics');
    }
  }

  Future<List<Job>> getIncomingJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$_baseUrl/jobs/incoming');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load incoming jobs');
    }
  }

  Future<ProviderProfile> toggleStatus(bool isOnline) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$_baseUrl/provider/me/status');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'isOnline': isOnline});

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return ProviderProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update status');
    }
  }
}
