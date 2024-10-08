import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000';

  // Fetch all products
  Future<Map<String, dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/products'));

    if (response.statusCode == 200) {
      // Decode JSON response and return it as a map
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch individual product by ID
  Future<Product> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/products/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Product.fromJson(data['product']);
    } else {
      throw Exception('Product not found');
    }
  }
}
