// ignore_for_file: use_build_context_synchronously

import 'package:attendance_ms/Components/custom_tiles.dart';
import 'package:attendance_ms/Providers/Auth/auth_provider.dart';
import 'package:attendance_ms/Screens/Admin/Report%20Generate/generate_report_screen.dart';
import 'package:attendance_ms/Screens/Admin/Attendance%20Records/view_attendance_screen.dart';
import 'package:attendance_ms/Screens/Admin/Request%20Records/user_leave_request_screen.dart';
import 'package:attendance_ms/Screens/Auth/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 15),
            onPressed: () async {
              try {
                setState(() {
                  isLoading = true;
                });
                await Future.delayed(const Duration(seconds: 2));

                await auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
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
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                    size: 27,
                  ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Column(
          children: [
            Tiles(
                title: "View Attendance",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ViewAttandanceScreen()));
                }),
            const SizedBox(
              height: 20,
            ),
            Tiles(
                title: "Manage Leave Requests",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const UserLeaveRequestScreen()));
                }),
            const SizedBox(
              height: 20,
            ),
            Tiles(
              title: "Generate Report",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GenerateReportScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
