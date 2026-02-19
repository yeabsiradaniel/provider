import 'dart:developer';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String role;
  final String? profilePhoto;
  final double? rating; // Added missing rating field
  final Location? location;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    this.profilePhoto,
    this.rating, // Added missing rating to constructor
    this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      role: json['role'],
      profilePhoto: json['profilePhoto'],
      rating: json['rating']?.toDouble(),
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'role': role,
      'profilePhoto': profilePhoto,
      'rating': rating,
      'location': location?.toJson(),
    };
  }
}

class Location {
  final double lat;
  final double lng;
  final DateTime updatedAt;

  Location({
    required this.lat,
    required this.lng,
    required this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
