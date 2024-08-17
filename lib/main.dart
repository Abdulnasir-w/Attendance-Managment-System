import 'package:attendance_ms/Screens/Auth/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
