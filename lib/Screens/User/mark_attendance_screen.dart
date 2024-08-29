import 'package:attendance_ms/Components/custom_button.dart';
import 'package:attendance_ms/Components/custom_profile_tabs.dart';
import 'package:attendance_ms/Providers/User/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/custom_snakbar.dart';
import '../../Providers/Auth/auth_provider.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  Future<bool>? _attendanceCheckFuture;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _attendanceCheckFuture = checkAttendanceStatus();
  }

  Future<bool> checkAttendanceStatus() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final attend = Provider.of<AttendanceProvider>(context, listen: false);

    if (auth.user != null) {
      await attend.checkAttendancedMarked(
        auth.auth.currentUser!.uid,
        DateTime.now(),
      );
      return attend.isAttendanceMarked;
    }
    return false;
  }

  Future<void> _markAttendance() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final attendance = Provider.of<AttendanceProvider>(context, listen: false);

    try {
      setState(() {
        isLoading = true;
      });
      await attendance.markAttendance(auth.user!.uId);
      if (!mounted) return;

      CustomSnakbar.showCustomSnackbar(
        context,
        message: "Attendance Marked Successfully",
        alignment: Alignment.bottomCenter,
        type: SnackBarType.success,
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      CustomSnakbar.showCustomSnackbar(
        context,
        message: e.toString(),
        alignment: Alignment.bottomCenter,
        type: SnackBarType.error,
      );

      setState(() {
        isLoading = false;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final today = DateTime.now();
    final dateKey = '${today.day}-${today.month}-${today.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mark Attendance",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: FutureBuilder<bool>(
          future: _attendanceCheckFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == false) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomProfileTabs(
                    title: "Name : ",
                    details: auth.user?.name ?? 'Unknown',
                  ),
                  const SizedBox(height: 20),
                  CustomProfileTabs(
                    title: "Date :",
                    details: dateKey,
                  ),
                  const SizedBox(height: 20),
                  MyCustomButton(
                    title: "Mark Attendance",
                    isLoading:
                        isLoading, // Replace with your loading state if needed
                    onPressed: _markAttendance,
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomProfileTabs(
                    title: "Name : ",
                    details: auth.user?.name ?? 'Unknown',
                  ),
                  const SizedBox(height: 20),
                  CustomProfileTabs(
                    title: "Date :",
                    details: dateKey,
                  ),
                  const SizedBox(height: 20),
                  const MyCustomButton(
                    title: "Already Attendance Marked",
                    isLoading:
                        false, // Replace with your loading state if needed
                    onPressed: null, // Disable button if already marked
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
