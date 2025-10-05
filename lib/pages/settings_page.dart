import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofence/pages/theme_page.dart';
import 'package:geofence/widgets/theme_picker.dart'; // ThemePickerButton to choose theme
import 'about_page.dart';


class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            leading: const Icon(Icons.color_lens),
            onTap: () {
              // Navigate to theme settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThemePickerButton(iconOnly: true,)),
              );
            },
          ),
          ListTile(
            title: const Text('About'),
            leading: const Icon(Icons.info),
            onTap: () {
              // Navigate to about screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
