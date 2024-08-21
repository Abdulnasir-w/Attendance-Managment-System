import 'package:attendance_ms/Components/custom_button.dart';
import 'package:attendance_ms/Screens/User/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../Providers/auth_provider.dart';
import '../Auth/sign_in_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "A M S",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen())),
              icon: const Icon(
                Icons.person_2_outlined,
                size: 35,
                color: Colors.white70,
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }
}
