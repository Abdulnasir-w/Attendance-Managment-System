import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLeaveRequestModel {
  final String userId;
  final String leaveRequestId;
  final String userName;
  final String date;
  final String reason;
  final String status;

  AdminLeaveRequestModel({
    required this.date,
    required this.reason,
    required this.userName,
    required this.status,
    required this.userId,
    required this.leaveRequestId,
  });

  factory AdminLeaveRequestModel.fromJson(DocumentSnapshot data) {
    return AdminLeaveRequestModel(
      date: data['userId'],
      reason: data['reason'],
      status: data['status'],
      userId: data['userId'],
      userName: data['userName'],
      leaveRequestId: data['leaveRequestId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'leaveRequestId': leaveRequestId,
      'date': date,
      'reason': reason,
      'userId': userId,
      'userName': userName,
      'status': status,
    };
  }
}
