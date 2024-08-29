import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Model/admin_leave_model.dart';

class AdminLeaveRequestProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fetch that user Who Submitted leave Requests

  Future<List<String>> fetchAllUser() async {
    try {
      // Fetch all documents from the 'Leave Requests' collection
      final QuerySnapshot querySnapshot =
          await firestore.collection("Leave Requests").get();

      // Extract and filter unique userIds from the documents
      List<String> userIds = querySnapshot.docs
          .map((doc) => doc['userId'] as String)
          .toSet()
          .toList();
      print(userIds);
      return userIds;
    } catch (e) {
      // Handle errors appropriately, perhaps log them or rethrow
      throw Exception('Error fetching documents: $e');
    }
  }

  // Future<List<AdminLeaveRequestModel>> fetchingPendingRequest() async {
  //   try {
  //     QuerySnapshot leaveRequestsSnapshot = await firestore
  //         .collection('Leave Requests')
  //         .where('status', isEqualTo: 'Pending')
  //         .get();

  //     List<AdminLeaveRequestModel> pendingRequests = [];
  //     for (var doc in leaveRequestsSnapshot.docs) {
  //       Map<String, dynamic> leaveRequestsData =
  //           doc.data() as Map<String, dynamic>;

  //       DocumentSnapshot userSnapshot = await firestore
  //           .collection('users')
  //           .doc(leaveRequestsData['userId'])
  //           .get();

  //       Map<String, dynamic> userData =
  //           userSnapshot.data() as Map<String, dynamic>;

  //       pendingRequests.add(AdminLeaveRequestModel(
  //           date: leaveRequestsData['date'],
  //           reason: leaveRequestsData['reason'],
  //           userName: userData['name'],
  //           status: leaveRequestsData['status'],
  //           userId: leaveRequestsData['userId'],
  //           leaveRequestId: doc.id));
  //     }
  //     return pendingRequests;
  //   } catch (e) {
  //     throw Exception("Error fetching pending leave requests: $e");
  //   }
  // }
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
