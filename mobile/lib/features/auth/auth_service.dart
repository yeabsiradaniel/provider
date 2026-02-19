import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
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

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp, Map<String, dynamic> userData) async {
    final url = Uri.parse('$_backendUrl/auth/verify-otp');
    final request = http.MultipartRequest('POST', url);

    // Add text fields
    request.fields['phoneNumber'] = phoneNumber;
    request.fields['otp'] = otp;
    userData.forEach((key, value) {
      if (value is String) {
        request.fields[key] = value;
      }
    });

    // Add profile photo file
    if (userData['profilePhoto'] != null && userData['profilePhoto'] is File) {
      File profilePhotoFile = userData['profilePhoto'];
      request.files.add(
        await http.MultipartFile.fromPath(
          'profilePhoto',
          profilePhotoFile.path,
          contentType: MediaType('image', 'jpeg'), // Adjust content type as needed
        ),
      );
    }
    
    // Add ID photo file
    if (userData['idPhoto'] != null && userData['idPhoto'] is File) {
      File idPhotoFile = userData['idPhoto'];
      request.files.add(
        await http.MultipartFile.fromPath(
          'idPhoto',
          idPhotoFile.path,
          contentType: MediaType('image', 'jpeg'), // Adjust content type as needed
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // We are not saving the user here anymore, the OtpScreen will handle it
      // based on the response.
      return data;
    } else {
      // Handle error response
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

  Future<void> saveAuthData(Map<String, dynamic> data) async {
    final user = User.fromJson(data['user']);
    await _saveToken(data['token']);
    await _saveUserToPrefs(user);
  }
}