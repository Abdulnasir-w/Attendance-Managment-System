import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Model/admin_leave_model.dart';

class AdminLeaveRequestProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fetch that user Who Submitted leave Requests
  Future<List<String>> fetchUserWithRequest() async {
    try {
      final requestUser = await firestore
          .collection("Leave Requests")
          // .doc("zFbmLFDw2qhyCa4TlpShkXrXvsB2")
          .get();

      // return requestUser.docs.map((doc) => doc.id).toList();
      // print("Request user id: ${requestUser.id}");
      // return [requestUser.id];
      final userIds = requestUser.docs
          .map((doc) => doc.data()['userId'] as String)
          .toList();

      return userIds;
    } catch (e) {
      print("Error fetching users: $e");
      throw e.toString();
    }
  }

  // Fetch all leave request for specific user
  Future<List<AdminLeaveRequestModel>> fetchSpecificLeaveRequest(
      String userId) async {
    try {
      final userRequests = await firestore
          .collection("Leave Requests")
          .doc(userId)
          .collection("requests")
          .where(
            "status",
            isEqualTo: "Pending",
          )
          .orderBy("timeStamp", descending: true)
          .get();

      return userRequests.docs.map((docs) {
        return AdminLeaveRequestModel(
          date: docs['date'],
          reason: docs['reason'],
          status: docs['status'],
          userId: docs.reference.parent.parent!.id,
          leaveRequestId: docs.id,
        );
      }).toList();
    } catch (e) {
      throw e.toString();
    }
  }

  // Approve or Reject requests

  Future<void> updateLeaveRequest(
      String userId, String status, String requestId) async {
    try {
      await firestore
          .collection("Leave Requests")
          .doc(userId)
          .collection("requests")
          .doc(requestId)
          .update({
        'status': status,
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }
}
