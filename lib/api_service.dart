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
  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Invalid login credentials');
    }
  }

// Register with better error handling
  Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirmation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorData = json.decode(response.body);

      // Check for validation errors
      if (errorData['errors'] != null) {
        // Return specific validation error
        throw Exception('Validation error: ${errorData['errors'].values.join(", ")}');
      } else {
        throw Exception('Registration failed: ${errorData['message'] ?? 'Unknown error'}');
      }
    }
  }

  // Logout
  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to log out');
    }
  }
}
