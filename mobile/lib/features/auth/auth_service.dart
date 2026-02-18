import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_state.dart';

class AuthService {
  final String _backendUrl = 'http://10.0.2.2:3001/api';

  Future<void> requestOtp(String phoneNumber) async {
    final url = Uri.parse('$_backendUrl/auth/request-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phoneNumber': phoneNumber}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to request OTP: ${response.body}');
    }
  }

  Future<User> verifyOtp(String phoneNumber, String otp) async {
    final url = Uri.parse('$_backendUrl/auth/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phoneNumber': phoneNumber, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final user = User.fromJson(data['user']);
      await _saveToken(data['token']);
      await _saveUserToPrefs(user);
      return user;
    } else {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }


  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    await prefs.remove('jwt_token');
  }

  Future<User?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      return User.fromJson(json.decode(userDataString));
    }
    return null;
  }

  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', json.encode(user.toJson()));
  }
}