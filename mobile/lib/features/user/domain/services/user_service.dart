import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:mobile/features/user/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class UserService {
  final String _baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator localhost

  Future<User> getMe() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    log('Token from storage: $token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/users/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      log('Failed to load user. Status code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to load user');
    }
  }

  Future<User> updateUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    log('--- Updating User ---');
    log('Token: $token');
    log('User Data: ${jsonEncode(userData)}');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );

    log('--- Update User Response ---');
    log('Status Code: ${response.statusCode}');
    log('Body: ${response.body}');

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      log('Failed to update user. Status code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to update user');
    }
  }

  Future<User> uploadProfilePicture(File image) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    log('--- Uploading Profile Picture ---');
    log('Auth Token: $token');
    log('Image Path: ${image.path}');

    if (token == null) {
      throw Exception('No token found');
    }

    // Look up the MIME type of the file
    final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
    final contentType = MediaType(mimeTypeData![0], mimeTypeData[1]);
    
    log('Content-Type: $contentType');

    final imageFile = await http.MultipartFile.fromPath(
      'profilePhoto',
      image.path,
      contentType: contentType,
    );

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/users/me/upload-photo'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(imageFile);
    
    log('Request Headers: ${request.headers}');
    log('Request Fields: ${request.fields}');
    log('Request Files: ${request.files.map((f) => '${f.field}: ${f.filename} (${f.contentType})').toList()}');

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();
    log('--- Upload Response ---');
    log('Status Code: ${response.statusCode}');
    log('Response Body: $responseBody');


    if (response.statusCode == 200) {
      return User.fromJson(json.decode(responseBody));
    } else {
      log('Failed to upload profile picture. Status code: ${response.statusCode}, Body: ${responseBody}');
      throw Exception('Failed to upload profile picture');
    }
  }
}