import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'product_model.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000'; // Emulator localhost

  // Fetch all products
  Future<Map<String, dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/products'));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return decoded JSON data
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

  // User Login
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
      final data = json.decode(response.body);

      if (data['token'] != null) { // Ensure token is present
        return data;
      } else {
        throw Exception('Login failed: No token returned.');
      }
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // User Register
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
      final data = json.decode(response.body);

      if (data['token'] != null) {
        return data;
      } else {
        throw Exception('Registration failed: No token returned.');
      }
    } else if (response.statusCode == 422) {
      final errorData = json.decode(response.body);
      throw Exception('Validation error: ${errorData['errors'].values.join(", ")}');
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  // User Logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token'); // Clear token on logout
        print('Successfully logged out');
      } else {
        throw Exception('Failed to log out');
      }
    } else {
      throw Exception('No token found. Unable to logout.');
    }
  }

  // Fetch cart items
  Future<Map<String, dynamic>> getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/api/cart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Return cart structure
      } else {
        throw Exception('Failed to load cart');
      }
    } else {
      throw Exception('No token found!');
    }
  }

  // Add product to cart
  Future<void> addToCart(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/cart/add/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add product to cart');
      }
    } else {
      throw Exception('User is not authenticated');
    }
  }

  // Remove product from cart
  Future<void> removeFromCart(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/cart/remove/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove product from cart');
      }
    } else {
      throw Exception('User is not authenticated');
    }
  }

  // Clear the cart
  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/cart/clear'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to clear cart');
      }
    } else {
      throw Exception('User is not authenticated');
    }
  }
}
