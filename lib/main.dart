import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_page.dart';  // Import ProductPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check if user is logged in
  }

  // Method to check if user has a valid token stored in SharedPreferences
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token'); // Retrieve token if available
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ORYX Products',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF202840),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      // Check if token is null, and navigate accordingly
      home: token == null ? const LoginPage() : HomePage(token: token ?? ''),  // Safely pass token
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => HomePage(token: token ?? ''), // Safely handle null token
        '/products': (context) => const ProductPage(),
      },
    );
  }
}
