// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:attendance_ms/Components/custom_button.dart';
import 'package:attendance_ms/Components/custom_profile_tabs.dart';
import 'package:attendance_ms/Components/custom_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Providers/auth_provider.dart';
import '../Auth/sign_in_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> getProfilePic(BuildContext context) async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (image != null) {
        authProvider.uploadPictoFirebaseStorage(image.path);
        const CustomSnakbar(
          alignment: Alignment.bottomCenter,
          type: SnackBarType.success,
          message: "Image Uploaded Successfully",
        );
      }
    } catch (e) {
      CustomSnakbar(
        alignment: Alignment.bottomCenter,
        type: SnackBarType.error,
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[100],
                  backgroundImage: user?.profilePicUrl != null
                      ? NetworkImage(user!.profilePicUrl.toString())
                      : null,
                  child: user?.profilePicUrl == null
                      ? const Icon(
                          Icons.person_2_outlined,
                          size: 80,
                          color: Colors.blue,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => getProfilePic(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 20,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            if (user != null) ...[
              CustomProfileTabs(
                title: 'Name :',
                details: user.name.toString(),
              ),
              const SizedBox(height: 20),
              CustomProfileTabs(
                title: 'Email :',
                details: user.email,
              ),
            ],
            const SizedBox(height: 40),
            MyCustomButton(
                title: "Logout",
                onPressed: () {
                  AuthProvider().signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
