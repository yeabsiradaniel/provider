import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/features/chat/domain/models/message.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
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

  Future<Message> postMessage(Map<String, dynamic> messageData) async {
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

    if (response.statusCode == 201) {
      return Message.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post message');
    }
  }

  Future<List<Job>> getConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final endpoint = '$_baseUrl/chat/conversations';
    if (kDebugMode) {
      log('===== CUSTOMER CHAT LIST REQUEST START =====');
      log('Endpoint: $endpoint');
      log('Token: $token');
    }

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      log('===== CUSTOMER CHAT LIST RESPONSE RAW =====');
      log('Status Code: ${response.statusCode}');
      log('Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load conversations');
    }
  }
}
