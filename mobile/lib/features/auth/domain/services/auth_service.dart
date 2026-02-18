import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/auth/domain/services/auth_exception.dart';


class AuthService {
  final String _baseUrl = 'http://10.0.2.2:3001/api/auth'; // Adjust if your backend runs on a different port

  Future<void> requestOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/request-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw AuthException(
          errorData['errorCode'] ?? 'UNKNOWN_ERROR',
          errorData['message'] ?? 'Failed to request OTP');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(
      String phoneNumber, String otp, Map<String, String> userData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'phoneNumber': phoneNumber,
        'otp': otp,
        ...userData,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['token']);
      await prefs.setString('userId', responseData['user']['_id']);
      return responseData;
    } else {
      final errorData = jsonDecode(response.body);
      throw AuthException(
          errorData['errorCode'] ?? 'UNKNOWN_ERROR',
          errorData['message'] ?? 'Failed to verify OTP');
    }
  }

  Future<void> resetPin(String phoneNumber, String otp, String newPin) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/reset-pin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'otp': otp,
        'newPin': newPin,
      }),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw AuthException(
          errorData['errorCode'] ?? 'UNKNOWN_ERROR',
          errorData['message'] ?? 'Failed to reset PIN');
    }
  }
}
