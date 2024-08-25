import 'package:attendance_ms/Model/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isAttendanceMarked = false;
  bool get isAttendanceMarked => _isAttendanceMarked;
  final today = DateTime.now();

  Future<void> checkAttendancedMarked(String userId) async {
    final dateKey = "${today.day}-${today.month}-${today.year}";
    try {
      final docs = await firestore
          .collection("Attendance")
          .doc(userId)
          .collection("dates")
          .doc(dateKey)
          .get();
      if (docs.exists) {
        _isAttendanceMarked = true;
      } else {
        _isAttendanceMarked = false;
      }
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  /// Mark Attendance
  Future<void> markAttendance(String userId) async {
    final dateKey = '${today.day}-${today.month}-${today.year}';
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
          .collection('Attendance')
          .doc(userId)
          .collection('dates')
          .doc(dateKey)
          .set({
        'status': "Present",
        "timeStamp": Timestamp.now(),
      });
      _isAttendanceMarked = true;
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
