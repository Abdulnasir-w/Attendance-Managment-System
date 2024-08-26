import 'package:attendance_ms/Components/custom_tiles.dart';
import 'package:attendance_ms/Providers/User/auth_provider.dart';
import 'package:attendance_ms/Screens/Admin/generate_report_screen.dart';
import 'package:attendance_ms/Screens/Admin/Attendance%20Records/managa_attendance_screen.dart';
import 'package:attendance_ms/Screens/Admin/Request%20Records/manage_leave_request_screen.dart';
import 'package:attendance_ms/Screens/Auth/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

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
            onPressed: () {
              auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
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
                          builder: (context) =>
                              const ManagaAttendanceScreen()));
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
                              const ManageLeaveRequestScreen()));
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
                }),
          ],
        ),
      ),
    );
  }
}
