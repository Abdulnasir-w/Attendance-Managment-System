import 'package:attendance_ms/Components/custom_button.dart';
import 'package:attendance_ms/Components/custom_profile_tabs.dart';
import 'package:attendance_ms/Components/custom_snakbar.dart';
import 'package:attendance_ms/Providers/attendance_provider.dart';
import 'package:attendance_ms/Providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  bool isLoading = false;
  bool isAttendaceMarked = false;

  @override
  void initState() {
    super.initState();
    checkAttendanceStatus();
  }

  Future<void> checkAttendanceStatus() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final attend = Provider.of<AttendanceProvider>(context, listen: false);

    await attend.checkAttendancedMarked(auth.user!.uId);
    if (mounted) {
      setState(() {
        isAttendaceMarked = attend.isAttendanceMarked;
      });
    }
  }

  Future<void> _markAttendance() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final attendance = Provider.of<AttendanceProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    try {
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
    final auth = Provider.of<AuthProvider>(context, listen: false);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomProfileTabs(
              title: "Name : ",
              details: auth.user!.name.toString(),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomProfileTabs(
              title: "Date :",
              details: dateKey,
            ),
            const SizedBox(
              height: 20,
            ),
            MyCustomButton(
              title: isAttendaceMarked
                  ? "Already Attendance Marked"
                  : "Mark Attendance",
              isLoading: isLoading,
              onPressed: isAttendaceMarked ? null : _markAttendance,
            )
          ],
        ),
      ),
    );
  }
}
