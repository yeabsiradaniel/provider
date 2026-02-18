import 'package:mobile/features/categories/domain/models/category.dart';
import 'package:mobile/features/user/domain/models/user.dart';
import 'package:mobile/features/provider_profile/domain/models/availability.dart';

class ProviderProfile {
  final User user;
  final String? idPhoto;
  final List<Category> serviceCategories;
  final int radius;
  final bool negotiable;
  final int earnings;
  final bool isOnline;
  final Map<String, DayAvailability> availability;

  ProviderProfile({
    required this.user,
    this.idPhoto,
    required this.serviceCategories,
    required this.radius,
    required this.negotiable,
    required this.earnings,
    required this.isOnline,
    required this.availability,
  });

  factory ProviderProfile.fromJson(Map<String, dynamic> json) {
    return ProviderProfile(
      user: User.fromJson(json['userId']),
      idPhoto: json['idPhoto'],
      serviceCategories: (json['serviceCategories'] as List? ?? [])
          .map((cat) => Category.fromJson(cat['category']))
          .toList(),
      radius: json['radius'] ?? 0,
      negotiable: json['negotiable'] ?? false,
      earnings: json['earnings'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      availability: (json['availability'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, DayAvailability.fromJson(value)),
      ),
    );
  }
}
