import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/categories/domain/models/category.dart';

class CategoryService {
  final String _baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator localhost

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      final categories = jsonResponse.map((category) => Category.fromJson(category)).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
