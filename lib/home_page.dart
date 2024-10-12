import 'package:flutter/material.dart';
import 'product_page.dart';  // Import ProductPage
import 'api_service.dart';

class HomePage extends StatelessWidget {
  final String token;
  final ApiService _apiService = ApiService();

  HomePage({Key? key, required this.token}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      await _apiService.logout(token);
      // Redirect to the login page after successful logout
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORYX Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),  // Logout when pressed
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to ORYX!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Here you can browse all products and manage your account.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the ProductPage when clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductPage()),
                );
              },
              child: const Text('View Products'),
            ),
          ],
        ),
      ),
    );
  }
}
