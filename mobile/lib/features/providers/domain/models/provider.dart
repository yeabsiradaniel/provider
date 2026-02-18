import 'package:mobile/features/providers/domain/models/provider_service.dart';
import 'package:mobile/features/user/domain/models/user.dart';

class Provider {
  final User user;
  final String? idPhoto;
  final List<ProviderService> serviceCategories;
  final int? radius;
  final bool? negotiable;
  final int earnings;
  final bool isOnline;
  final double distance;

  Provider({
    required this.user,
    this.idPhoto,
    required this.serviceCategories,
    this.radius,
    this.negotiable,
    required this.earnings,
    required this.isOnline,
    required this.distance,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      user: User.fromJson(json['userId']),
      idPhoto: json['idPhoto'],
      serviceCategories: (json['serviceCategories'] as List? ?? [])
          .map((service) => ProviderService.fromJson(service))
          .toList(),
      radius: json['radius'],
      negotiable: json['negotiable'],
      earnings: json['earnings'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      distance: (json['distance'] as num?)?.toDouble() ?? double.infinity,
    );
  }
}
