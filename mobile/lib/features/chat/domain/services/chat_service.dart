import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/chat/domain/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final String _baseUrl = 'http://10.0.2.2:3001/api';

  Future<List<Message>> getMessages(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/chat/$jobId/messages'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((msg) => Message.fromJson(msg)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> postMessage(Map<String, dynamic> messageData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/message'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(messageData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to post message');
    }
  }
}
