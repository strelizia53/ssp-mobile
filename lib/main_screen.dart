import 'package:flutter/material.dart';
import 'home_page.dart';
import 'product_page.dart';
import 'cart_page.dart';
import 'settings_page.dart'; // Placeholder for Settings Page

class MainScreen extends StatefulWidget {
  final String token;

  const MainScreen({Key? key, required this.token}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of pages for each tab
  final List<Widget> _pages = [
    HomePage(token: ''), // Pass the token properly to HomePage
    ProductPage(), // Products Page
    CartScreen(), // Cart Page
    SettingsPage(), // Settings Page Placeholder
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar since it's removed
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF202840), // Dark background
        selectedItemColor: Colors.pinkAccent, // Color of the selected item
        unselectedItemColor: Colors.grey, // Darker gray for better visibility
        currentIndex: _selectedIndex, // Current tab index
        onTap: _onItemTapped, // Handle tab change
        showSelectedLabels: false, // Hide the labels for selected items
        showUnselectedLabels: false, // Hide the labels for unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '', // No label
          ),
        ],
      ),
    );
  }
}
