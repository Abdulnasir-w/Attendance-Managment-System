import 'package:attendance_ms/Components/custom_button.dart';
import 'package:flutter/material.dart';

import '../../Providers/auth_provider.dart';
import '../Auth/sign_in_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "User Home Screen",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          MyCustomButton(
              title: "sign Out",
              onPressed: () {
                AuthProvider().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }),
        ],
      ),
    );
  }
}
