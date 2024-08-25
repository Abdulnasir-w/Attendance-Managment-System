import 'package:attendance_ms/Model/leave_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaveRequestProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Request Leave
  Future<void> requestLeave(String userId, String date, String reason) async {
    try {
      await firestore
          .collection('Leave Requests')
          .doc(userId)
          .collection('requests')
          .add({
        'date': date,
        'reason': reason,
        'status': "Pending",
        'timeStamp': Timestamp.now(),
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  // Get Leave Request For user

  Future<List<LeaveRequestModel>> getLeaveRequest(String userId) async {
    try {
      final req = await firestore
          .collection("Leave Requests")
          .doc(userId)
          .collection("requests")
          .orderBy("timeStamp", descending: true)
          .get();

      return req.docs.map((doc) {
        return LeaveRequestModel(
          date: doc['date'],
          reason: doc['reason'],
          status: doc['status'],
        );
      }).toList();
    } catch (e) {
      throw e.toString();
    }
  }
}
