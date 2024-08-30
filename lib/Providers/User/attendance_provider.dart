import 'package:attendance_ms/Model/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isAttendanceMarked = false;
  bool get isAttendanceMarked => _isAttendanceMarked;
  final today = DateTime.now();

  void reset() {
    _isAttendanceMarked = false;
    notifyListeners();
  }

  Future<void> checkAttendancedMarked(String userId, DateTime date) async {
    final dateKey = "${date.day}-${date.month}-${date.year}";
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
          .orderBy('timeStamp', descending: false)
          .get();

      final List<AttendanceModel> attendanceList = [];
      final now = DateTime.now();
      final startOfTheMonth = DateTime(now.year, now.month, 1);

      // Convert Firestore docs to a map for quick lookup
      final attendanceMap = {
        for (var doc in getAttendances.docs) doc.id: doc['status']
      };

      for (int i = 0; i < now.day; i++) {
        final date = startOfTheMonth.add(Duration(days: i));
        final dateKey = "${date.day}-${date.month}-${date.year}";

        final status = attendanceMap[dateKey] ?? 'Absent';
        attendanceList.add(
          AttendanceModel(date: dateKey, status: status),
        );

        // Add "Absent" entry to Firestore if not already present
        if (status == 'Absent') {
          await firestore
              .collection('Attendance')
              .doc(userId)
              .collection('dates')
              .doc(dateKey)
              .set(
                  {
                'status': 'Absent',
                'timeStamp': Timestamp.now(),
              },
                  SetOptions(
                      merge: true)); // Merge to avoid overwriting existing data
        }
      }
      // final List<AttendanceModel> attendanceList = [];
      // final now = DateTime.now();
      // final startOfTheMonth = DateTime(now.year, now.month, 1);

      // for (int i = 0; i < now.day; i++) {
      //   final date = startOfTheMonth.add(Duration(days: i));
      //   final dateKey = "${date.day}-${date.month}-${date.year}";

      //   final attedanceDoc = getAttendances.docs.firstWhere(
      //     (doc) => doc.id == dateKey,
      //   );

      //   if (attedanceDoc.exists) {
      //     attendanceList.add(AttendanceModel(
      //       date: dateKey,
      //       status: attedanceDoc['status'],
      //     ));
      //   } else {
      //     await firestore
      //         .collection("Attendance")
      //         .doc(userId)
      //         .collection('dates')
      //         .doc(dateKey)
      //         .set({
      //       'status': " Absent ",
      //       "timeStamp": Timestamp.now(),
      //     });
      //     attendanceList.add(
      //       AttendanceModel(date: dateKey, status: 'Absent'),
      //     );
      //   }
      // }
      return attendanceList;
    } catch (e) {
      throw e.toString();
    }
  }
}
