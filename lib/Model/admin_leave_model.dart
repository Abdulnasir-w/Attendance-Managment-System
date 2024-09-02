import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLeaveRequestModel {
  final String leaveRequestId;
  final String date;
  final String reason;
  final String status;

  AdminLeaveRequestModel({
    required this.date,
    required this.reason,
    required this.status,
    required this.leaveRequestId,
  });

  factory AdminLeaveRequestModel.fromJson(DocumentSnapshot data) {
    return AdminLeaveRequestModel(
      date: data['date'] ?? '', // Fallback to an empty string if null
      reason: data['reason'] ?? '',
      status: data['status'] ?? '',
      leaveRequestId: data['leaveRequestId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'leaveRequestId': leaveRequestId,
      'date': date,
      'reason': reason,
      'status': status,
    };
  }
}
