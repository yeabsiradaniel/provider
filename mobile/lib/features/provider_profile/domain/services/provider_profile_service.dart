import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/provider_profile/domain/models/provider_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderProfileService {
  final String _baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator localhost

  Future<ProviderProfile> getMe() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$_baseUrl/provider/profile/me');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    
    if (response.statusCode == 200) {
      return ProviderProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load provider profile. Status: ${response.statusCode}');
    }
  }
}
