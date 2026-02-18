import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/search/domain/models/search_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchService {
  final String _baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator localhost

  Future<List<SearchResult>> getSuggestions(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final uri = Uri.parse('$_baseUrl/search/suggestions?query=$query');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((result) => SearchResult.fromJson(result)).toList();
    } else {
      throw Exception('Failed to load search suggestions');
    }
  }
}
