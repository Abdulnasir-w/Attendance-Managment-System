import 'dart:async';

import 'package:attendance_ms/Providers/Auth/auth_provider.dart';
import 'package:attendance_ms/Screens/Admin/home_screen.dart';
import 'package:attendance_ms/Screens/Auth/sign_in_screen.dart';
import 'package:attendance_ms/Screens/User/home_screen.dart';
import 'package:attendance_ms/no_internet_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.none)) {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const NoInternetScreen()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        if (!isChecked) {
          checkStatus();
        }
      }
    });
    initSplashScreen();
  }

  Future<void> initSplashScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    checkStatus();
  }

  void checkStatus() async {
    if (isChecked) return; // Prevent multiple checks

    setState(() {
      isChecked = true;
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.fetchUserData();

    if (authProvider.isLoggedIn()) {
      if (authProvider.isAdmin()) {
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AdminHomeScreen()));
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const UserHomeScreen()));
        }
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }
    setState(() {
      isChecked = false;
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Attendance Managment \n System",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
