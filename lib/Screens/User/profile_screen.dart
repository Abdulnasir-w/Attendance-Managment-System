// ignore_for_file: use_build_context_synchronously

import 'package:attendance_ms/Components/custom_button.dart';
import 'package:attendance_ms/Components/custom_profile_tabs.dart';
import 'package:attendance_ms/Utils/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/Auth/auth_provider.dart';
import '../Auth/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<void> _fetchUserDataFuture;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDataFuture =
        Provider.of<AuthProvider>(context, listen: false).fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<void>(
        future: _fetchUserDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (authProvider.user == null) {
            return const Center(child: Text('No user data available.'));
          } else {
            final user = authProvider.user!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ProfilePicture(),
                  const SizedBox(height: 70),
                  CustomProfileTabs(
                      title: 'Name :', details: user.name.toString()),
                  const SizedBox(height: 20),
                  CustomProfileTabs(title: 'Email :', details: user.email),
                  const SizedBox(height: 40),
                  MyCustomButton(
                    title: "Logout",
                    isLoading: isLoading,
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        await Future.delayed(const Duration(seconds: 2));
                        await authProvider.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        throw e.toString();
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
