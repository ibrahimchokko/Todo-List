// Settings screen for the app. Contains a few toggles and simple dialogs.
// Note: Many actions are currently mock/stub (e.g., clearing tasks) and
// should be wired to real app state or persistence in a future iteration.
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Local UI state for toggles and a profile name shown in the UI.
  // These are not persisted between app runs in the current implementation.
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _profileName = "John Doe";

  // Dialog for editing profile name. Updates local state when saved.
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

  // Dialog for clearing all tasks - currently mock logic that shows a snackbar.
  // In a full implementation this should call the task manager / persistence
  // layer to actually remove the tasks.
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

  // Simple about dialog that uses Flutter's built-in showAboutDialog.
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "FocusFlow To-Do",
      applicationVersion: "1.0.0",
      applicationLegalese: "\u00a9 2025 ChokoDev",
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

          // Profile Section - editable profile name stored in local state.
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile Name"),
            subtitle: Text(_profileName),
            trailing: const Icon(Icons.edit, color: Colors.blueAccent),
            onTap: _editProfileName,
          ),
          const Divider(),

          // Dark Mode Toggle - toggles local UI state only. To actually
          // switch app themes, this should integrate with an InheritedWidget
          // / Provider / Riverpod that controls ThemeMode in MaterialApp.
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Dark Mode ${value ? 'Enabled \ud83c\udf19' : 'Disabled \u2600\ufe0f'}",
                  ),
                ),
              );
            },
          ),
          const Divider(),

          // Notification Toggle - local toggle only.
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text("Enable Notifications"),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          const Divider(),

          // Clear Tasks - placeholder for destructive action.
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: const Text("Clear All Tasks"),
            onTap: _clearAllTasks,
          ),
          const Divider(),

          // About App - shows app metadata.
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
