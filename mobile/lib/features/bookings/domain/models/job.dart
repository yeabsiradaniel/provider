import 'dart:developer';
import 'package:mobile/features/user/domain/models/user.dart';

class Job {
  final String id;
  final User? clientId;
  final User? providerId;
  final String serviceName;
  final int? agreedPrice;
  final String? description;
  final String status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final DateTime? startDate;
  final DateTime? endDate;

  Job({
    required this.id,
    this.clientId,
    this.providerId,
    required this.serviceName,
    this.agreedPrice,
    this.description,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
    this.startDate,
    this.endDate,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    User? parseUser(dynamic userData) {
      if (userData is Map<String, dynamic>) {
        return User.fromJson(userData);
      }
      if (userData is String) {
        // Create a placeholder if we just get an ID string
        return User(id: userData, firstName: 'Unknown', lastName: '', phone: '', role: 'client');
      }
      return null;
    }

    return Job(
      id: json['_id'],
      clientId: parseUser(json['clientId']),
      providerId: parseUser(json['providerId']),
      serviceName: json['serviceName'],
      agreedPrice: json['agreedPrice'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
    );
  }
}
