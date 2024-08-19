import 'package:attendance_ms/Components/custom_button.dart';
import 'package:attendance_ms/Providers/auth_provider.dart';
import 'package:attendance_ms/Screens/Auth/sign_in_screen.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Admin Home Screen",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 20,
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
