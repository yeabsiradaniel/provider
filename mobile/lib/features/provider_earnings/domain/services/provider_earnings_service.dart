import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/provider_earnings/domain/models/provider_earnings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderEarningsService {
  final String _baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator localhost

  Future<ProviderEarnings> getEarnings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$_baseUrl/provider/me/earnings');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    
    if (response.statusCode == 200) {
      return ProviderEarnings.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load earnings');
    }
  }
}
