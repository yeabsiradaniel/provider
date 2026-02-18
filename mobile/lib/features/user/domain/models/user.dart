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
    log('---- USER.fromJson START ----');
    log('[User.fromJson] Full input JSON: $json');

    final id = json['_id'];
    final firstName = json['firstName'];
    final lastName = json['lastName'];
    final phone = json['phone'];
    final role = json['role'];
    
    log('[User.fromJson] _id: "$id" (type: ${id.runtimeType})');
    log('[User.fromJson] firstName: "$firstName" (type: ${firstName.runtimeType})');
    log('[User.fromJson] lastName: "$lastName" (type: ${lastName.runtimeType})');
    log('[User.fromJson] phone: "$phone" (type: ${phone.runtimeType})');
    log('[User.fromJson] role: "$role" (type: ${role.runtimeType})');

    if (id == null) log('[User.fromJson] ERROR: Missing required field: _id');
    if (firstName == null) log('[User.fromJson] ERROR: Missing required field: firstName');
    if (lastName == null) log('[User.fromJson] ERROR: Missing required field: lastName');
    if (phone == null) log('[User.fromJson] ERROR: Missing required field: phone');
    if (role == null) log('[User.fromJson] ERROR: Missing required field: role');

    final finalUser = User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      role: role,
      profilePhoto: json['profilePhoto'],
      rating: json['rating']?.toDouble(),
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
    );
    log('[User.fromJson] Constructed User object with id: ${finalUser.id} and role: ${finalUser.role}');
    log('---- USER.fromJson END ----');
    return finalUser;
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
}
