import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminLeaveRequestProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _users = [];
  List<String> _userIdsWithRequests = [];
  List<Map<String, dynamic>> get users => _users;

  // Fetch all users
  Future<void> fetchAllUsers() async {
    try {
      QuerySnapshot userSnapshot = await firestore.collection('users').get();
      userSnapshot.docs.map((docs) => docs.id).toList();

      await fetchUsersWhoSendRequests();

      // Filter users to show only those with leave requests
      _users = userSnapshot.docs
          .where((doc) => _userIdsWithRequests.contains(doc.id))
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  // Fetch that user Who Submitted leave Requests
  Future<void> fetchUsersWhoSendRequests() async {
    try {
      final users = await firestore.collection('users').get();
      List<String> userIdsWithRequests = [];

      for (var doc in users.docs) {
        final userId = doc.id;
        final leaveRequest = await firestore
            .collection("Leave Requests")
            .doc(userId)
            .collection("requests")
            .get();
        if (leaveRequest.docs.isNotEmpty) {
          userIdsWithRequests.add(userId);
        }
        _userIdsWithRequests = userIdsWithRequests;
      }
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }
}
