import 'package:attendance_ms/Screens/User/leave_request_screen.dart';
import 'package:attendance_ms/Screens/User/mark_attendance_screen.dart';
import 'package:attendance_ms/Screens/User/profile_screen.dart';
import 'package:attendance_ms/Screens/User/view_attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Components/custom_tiles.dart';
import 'check_request_screen.dart';

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
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfileScreen())),
            icon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: SvgPicture.asset(
                "assets/profile.svg",
                width: 37,
                height: 37,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Tiles(
              title: 'Mark Attendance',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MarkAttendanceScreen(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Tiles(
              title: 'View Attendance',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAttendanceScreen(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Tiles(
              title: 'Request For Leave',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeaveRequestScreen(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Tiles(
              title: 'Check  Requests',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckRequestScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
