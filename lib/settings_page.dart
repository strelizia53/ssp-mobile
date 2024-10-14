import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Settings', style: TextStyle(fontSize: 24)),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeNotifier.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeNotifier.setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
        ],
      ),
    );
  }
}
