import 'package:mobile/features/categories/domain/models/category.dart';

class ProviderService {
  final Category category;
  final int? price;

  ProviderService({
    required this.category,
    this.price,
  });

  factory ProviderService.fromJson(Map<String, dynamic> json) {
    return ProviderService(
      category: Category.fromJson(json['category']),
      price: json['price'],
    );
  }
}
