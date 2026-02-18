import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String role;
  final String phone;
  final String? name;
  final double rating;
  final bool verified;

  const User({
    required this.id,
    required this.role,
    required this.phone,
    this.name,
    this.rating = 0,
    this.verified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      role: json['role'],
      phone: json['phone'],
      name: json['name'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'role': role,
      'phone': phone,
      'name': name,
      'rating': rating,
      'verified': verified,
    };
  }
}

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthCodeSent extends AuthState {
    const AuthCodeSent();
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// Represents a new user who needs to select a role
class AuthNeedsRoleSelection extends AuthState {
    const AuthNeedsRoleSelection();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
