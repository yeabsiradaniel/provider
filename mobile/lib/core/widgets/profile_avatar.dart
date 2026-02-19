import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile/core/config.dart';

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
    ImageProvider backgroundImage;

    if (imageUrl.startsWith('/uploads/')) {
      // New flow: relative path from server
      final fullUrl = '$baseUrl$imageUrl';
      backgroundImage = NetworkImage(fullUrl);
    } else if (imageUrl.startsWith('/data/')) {
      // Old flow: absolute local file path
      backgroundImage = FileImage(File(imageUrl));
    } else if (imageUrl.startsWith('http')) {
      // Already a full URL
      backgroundImage = NetworkImage(imageUrl);
    } else {
      // Placeholder
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
        // Optionally log or handle image loading errors silently
      },
    );
  }
}
