import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const ProfileAvatar({
    Key? key,
    required this.imageUrl,
    this.radius = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('ProfileAvatar: Building with imageUrl: "$imageUrl"');
    final String _baseUrl = 'http://10.0.2.2:3001'; // Android emulator localhost
    ImageProvider backgroundImage;

    // Check if it's a valid ObjectId (24 hex characters)
    final isObjectId = imageUrl.length == 24 && RegExp(r'^[0-9a-fA-F]+$').hasMatch(imageUrl);

    if (isObjectId) {
      final fullUrl = '$_baseUrl/api/users/photo/$imageUrl';
      log('ProfileAvatar: Detected GridFS ID. Constructing URL: $fullUrl');
      backgroundImage = NetworkImage(fullUrl);
    } else if (imageUrl.startsWith('http')) {
      log('ProfileAvatar: Detected http URL.');
      backgroundImage = NetworkImage(imageUrl);
    } else if (imageUrl.isNotEmpty) {
      log('ProfileAvatar: Detected local file path.');
      backgroundImage = FileImage(File(imageUrl));
    } else {
      log('ProfileAvatar: ImageUrl is empty, using default.');
      // I am not adding a default avatar asset as it does not exist.
      // Instead, I'll use a placeholder icon.
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade300,
        child: Icon(Icons.person, size: radius, color: Colors.grey.shade600),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: backgroundImage,
      onBackgroundImageError: (exception, stackTrace) {
        log('ProfileAvatar: Error loading image.', error: exception, stackTrace: stackTrace);
      },
    );
  }
}
