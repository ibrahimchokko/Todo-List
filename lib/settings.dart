import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _profileName = "John Doe";

  // Dialog for editing profile name
  void _editProfileName() {
    String newName = _profileName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile Name"),
          content: TextField(
            decoration: const InputDecoration(hintText: "Enter your name"),
            onChanged: (value) => newName = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (newName.trim().isNotEmpty) {
                  setState(() {
                    _profileName = newName.trim();
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Dialog for clearing all tasks (just mock logic)
  void _clearAllTasks() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Clear All Tasks"),
          content: const Text(
            "Are you sure you want to clear all your tasks? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement task clearing logic later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All tasks cleared!")),
                );
                Navigator.pop(context);
              },
              child: const Text("Clear"),
            ),
          ],
        );
      },
    );
  }

  // Simple about info
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "FocusFlow To-Do",
      applicationVersion: "1.0.0",
      applicationLegalese: "© 2025 ChokoDev",
      children: [
        const Text(
          "FocusFlow is a smart to-do list app with timer tracking and productivity tools.",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // Profile Section
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile Name"),
            subtitle: Text(_profileName),
            trailing: const Icon(Icons.edit, color: Colors.blueAccent),
            onTap: _editProfileName,
          ),
          const Divider(),

          // Dark Mode Toggle
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Dark Mode ${value ? 'Enabled 🌙' : 'Disabled ☀️'}",
                  ),
                ),
              );
            },
          ),
          const Divider(),

          // Notification Toggle
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text("Enable Notifications"),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          const Divider(),

          // Clear Tasks
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: const Text("Clear All Tasks"),
            onTap: _clearAllTasks,
          ),
          const Divider(),

          // About App
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About App"),
            onTap: _showAboutDialog,
          ),
        ],
      ),
    );
  }
}
