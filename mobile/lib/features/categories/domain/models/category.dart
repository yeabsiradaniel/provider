class Category {
  final String id;
  final Map<String, String> name;
  final String? icon;
  final List<Category> subCategories;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.subCategories = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var subCategoriesList = json['subCategories'] as List? ?? [];
    List<Category> parsedSubCategories = subCategoriesList
        .map((subCategoryJson) => Category.fromJson(subCategoryJson))
        .toList();

    return Category(
      id: json['_id'],
      name: Map<String, String>.from(json['name']),
      icon: json['icon'],
      subCategories: parsedSubCategories,
    );
  }
}
