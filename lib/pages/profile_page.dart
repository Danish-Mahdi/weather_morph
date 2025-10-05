import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current user details
    final User? user = FirebaseAuth.instance.currentUser;

    // If the user is null (not logged in), show login page
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('No user logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Navigate back to login screen or splash screen
              Navigator.pushReplacementNamed(context, '/login_register_page');
            },
          )
        ],
      ),
      body: Center( // Center the content of the screen
        child: SingleChildScrollView( // Allow scrolling if content overflows
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding around the screen
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Display user photo with fallback to a default image if photo is null
                CircleAvatar(
                  radius: 70, // Increase the size of the photo
                  backgroundImage: NetworkImage(
                    user.photoURL ??
                        'https://www.example.com/default_profile_pic.png',
                  ),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 20), // Add some space below the photo

                // Display user name, if null use a fallback text
                Text(
                  user.displayName ?? 'No name available',
                  style: const TextStyle(
                    fontSize: 24, // Larger font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // Display user email
                Text(
                  user.email ?? 'No email available',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Optionally, display other user details like phone number
                if (user.phoneNumber != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Phone Number: ${user.phoneNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],

                // Add a button to edit profile if you want (optional)
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to edit profile screen
                    // You can implement this if you allow users to edit their profile
                    Navigator.pushNamed(context, '/edit_profile');
                  },
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
