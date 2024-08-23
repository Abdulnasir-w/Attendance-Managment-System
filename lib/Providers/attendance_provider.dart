import 'package:attendance_ms/Model/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Mark Attendance
  Future<void> markAttendance(String userId) async {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';

    try {
      final docs = await firestore
          .collection('Attendance')
          .doc(userId)
          .collection('dates')
          .doc(dateKey)
          .get();

      if (docs.exists) {
        throw 'Your Attendance Already Marked For today!';
      }

      await firestore
          .collection('Attendace')
          .doc(userId)
          .collection('dates')
          .doc(dateKey)
          .set({
        'status': "Present",
        "timeStamp": Timestamp.now(),
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  /// Get All Attendance of User
  Future<List<AttendanceModel>> getAttendanceRecords(String userId) async {
    try {
      final getAttendances = await firestore
          .collection('Attendance')
          .doc(userId)
          .collection('dates')
          .orderBy('timeStamp', descending: true)
          .get();

      return getAttendances.docs.map((docs) {
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
