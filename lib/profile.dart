// Simple profile screen used from the app drawer.
// This is primarily a static placeholder demonstrating typical profile
// UI parts: avatar, name, bio, contact info and an edit action.
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile"),
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture (network image). In production replace with
            // a locally cached image or user-uploaded avatar.
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueGrey.shade100,
              child: ClipOval(
                child: Image.network(
                  "https://i.pravatar.cc/150?img=3",
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Name
            const Text(
              "John Doe",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Email
            const Text(
              "johndoe@email.com",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Bio / Description card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "About Me",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Passionate Flutter developer and content creator. "
                      "Loves building intuitive apps and experimenting with UI/UX design. "
                      "Coffee addict \u2615, gamer \ud83c\udfae, and lifelong learner. ",
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Account Information (static placeholders)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text("Phone"),
                    subtitle: Text("+234 810 642 5357"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text("Location"),
                    subtitle: Text("Kaduna, Nigeria"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons - Edit profile is a placeholder for future logic.
            ElevatedButton.icon(
              onPressed: () {
                // Edit Profile logic (not implemented) — kept as a stub.
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade800,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
