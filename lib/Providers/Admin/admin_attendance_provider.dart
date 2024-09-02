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
      final now = DateTime.now();
      final startOfMonth =
          DateTime(now.year, now.month, 1); // Start of the current month
      final endOfMonth =
          DateTime(now.year, now.month + 1, 0); // End of the current month

      // Fetch attendance records for the current month
      final userAttendance = await firestore
          .collection('Attendance')
          .doc(userId)
          .collection('dates')
          .where('timeStamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('timeStamp',
              isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .orderBy('timeStamp', descending: false)
          .get();

      final List<AttendanceModel> attendanceList = [];
      final attendanceMap = {
        for (var doc in userAttendance.docs) doc.id: doc['status']
      };

      // Loop through each day of the current month
      for (int i = 0; i < endOfMonth.day; i++) {
        final date = DateTime(now.year, now.month, i + 1);
        final dateKey = "${date.day}-${date.month}-${date.year}";

        // Skip future dates
        if (date.isAfter(now)) continue;

        final status = attendanceMap[dateKey] ?? null;

        // Only add the entry if status is marked
        if (status != null) {
          attendanceList.add(
            AttendanceModel(date: dateKey, status: status),
          );
        }
      }

      return attendanceList;
    } catch (e) {
      throw e.toString();
    }
  }
}
