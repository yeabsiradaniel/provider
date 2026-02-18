import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderScheduleService {
  final String _baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator localhost

  Future<List<Job>> getProviderSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$_baseUrl/jobs/provider/schedule');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load provider schedule');
    }
  }
}
