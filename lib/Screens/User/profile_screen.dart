// ignore_for_file: use_build_context_synchronously

import 'package:attendance_ms/Components/custom_button.dart';
import 'package:attendance_ms/Components/custom_profile_tabs.dart';
import 'package:attendance_ms/Utils/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/Auth/auth_provider.dart';
import '../Auth/sign_in_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ProfilePicture(),
            const SizedBox(height: 70),
            CustomProfileTabs(
              title: 'Name :',
              details: user!.name.toString(),
            ),
            const SizedBox(height: 20),
            CustomProfileTabs(
              title: 'Email :',
              details: user.email,
            ),
            const SizedBox(height: 40),
            MyCustomButton(
                title: "Logout",
                onPressed: () async {
                  AuthProvider().signOut();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
