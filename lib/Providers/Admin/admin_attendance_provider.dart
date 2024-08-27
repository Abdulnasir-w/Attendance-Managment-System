import 'package:attendance_ms/Model/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAttendanceProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fetch
  Future<List<Map<String, dynamic>>> fetchAllUser() async {
    try {
      final user = await firestore.collection('users').get();
      return user.docs
          .map((docs) => {"id": docs.id, "name": docs['name']})
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }

  // Fetch user Attendance
  Future<List<AttendanceModel>> fetchUserAttendance(String userId) async {
    try {
      final user = await firestore
          .collection('Attendance')
          .doc(userId)
          .collection('dates')
          .orderBy('timeStamp', descending: false)
          .get();

      return user.docs.map((docs) {
        return AttendanceModel(
          date: docs.id,
          status: docs['status'],
        );
      }).toList();
    } catch (e) {
      throw e.toString();
    }
  }
}
