import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProviderService {
  final String _baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator localhost

  Future<void> updateCategories(List<String> categoryIds) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/provider/me/categories'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'categoryIds': categoryIds}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update categories');
    }
  }

  Future<void> updateServices(List<Map<String, dynamic>> services) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/provider/services'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'services': services}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update services');
    }
  }
}
