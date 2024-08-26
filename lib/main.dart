import 'package:attendance_ms/Providers/Admin/admin_leave_request_provider.dart';
import 'package:attendance_ms/Providers/User/attendance_provider.dart';
import 'package:attendance_ms/Providers/User/auth_provider.dart';
import 'package:attendance_ms/Providers/User/leave_request_provider.dart';
import 'package:attendance_ms/Screens/Auth/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDcv8_swjT-wSI65_KF5VBBEJvJCPvD6SE",
        appId: "1:203918850128:android:47ed31634b38354ae8f955",
        messagingSenderId: "203918850128",
        projectId: "attendance-management-sy-2d003",
        storageBucket: "attendance-management-sy-2d003.appspot.com"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LeaveRequestProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => AdminLeaveRequestProvider()),
      ],
      child: const MaterialApp(
        title: "Attendance Management System",
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
