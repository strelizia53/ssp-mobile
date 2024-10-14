import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // Method to handle logout
  Future<void> _logout(BuildContext context) async {
    try {
      await ApiService().logout();  // Call logout API
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');  // Clear token
      Navigator.pushReplacementNamed(context, '/login');  // Navigate to login screen
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Settings', style: TextStyle(fontSize: 24)),

          // Dark Mode Switch
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeNotifier.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeNotifier.setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),

          // Logout Button
          ElevatedButton(
            onPressed: () => _logout(context),  // Trigger logout
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}