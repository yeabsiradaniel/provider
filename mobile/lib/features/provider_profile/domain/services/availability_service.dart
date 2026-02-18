import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/provider_profile/domain/models/availability.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvailabilityService {
  final String _baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator localhost

  Future<Map<String, DayAvailability>> getAvailability() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/provider/me/availability'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map(
        (key, value) => MapEntry(key, DayAvailability.fromJson(value)),
      );
    } else {
      throw Exception('Failed to load availability');
    }
  }

  Future<void> updateAvailability(
      Map<String, DayAvailability> availability) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/provider/me/availability'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'availability':
            availability.map((key, value) => MapEntry(key, value.toJson())),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update availability');
    }
  }
}
