import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Navigator.pushNamed(context, '/products');
              },
              child: const Text('View Products'),
            ),
          ],
        ),
      ),
    );
  }
}
