import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/providers/domain/models/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderService {
  final String _baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator localhost

  Future<List<Provider>> searchProviders(List<String> categoryIds, Position? userLocation) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }
    
    final queryParameters = {
      'categoryIds': categoryIds.join(','),
      if (userLocation != null) 'lat': userLocation.latitude.toString(),
      if (userLocation != null) 'lng': userLocation.longitude.toString(),
    };
    final uri = Uri.parse('$_baseUrl/providers/search').replace(queryParameters: queryParameters);
    
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      final providers = jsonResponse.map((provider) => Provider.fromJson(provider)).toList();
      return providers;
    } else {
      throw Exception('Failed to load providers');
    }
  }
  Future<Provider> getProvider(String providerId) async {
    // Note: This endpoint does not seem to require auth in the backend routes, but it's good practice
    // to send the token if available, in case permissions change.
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/provider/profile/$providerId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    if (response.statusCode == 200) {
      return Provider.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load provider');
    }
  }
}
