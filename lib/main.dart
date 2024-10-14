import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'ORYX Products',
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.pinkAccent,
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.pinkAccent,
                brightness: Brightness.light,  // Ensure consistency here
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.black),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF202840),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.pinkAccent,
                brightness: Brightness.dark,  // Ensure consistency here
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
              ),
            ),
            themeMode: themeNotifier.themeMode,  // Use ThemeNotifier to manage themeMode
            home: token == null ? const LoginPage() : MainScreen(token: token!), // MainScreen requires token
            routes: {
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/home': (context) => MainScreen(token: token!), // Ensure the token is passed
            },
          );
        },
      ),
    );
  }
}
