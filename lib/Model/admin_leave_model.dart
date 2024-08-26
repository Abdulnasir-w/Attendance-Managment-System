class AdminLeaveRequestModel {
  final String userId;
  final String leaveRequestId;
  final String date;
  final String reason;
  final String status;

  AdminLeaveRequestModel({
    required this.date,
    required this.reason,
    required this.status,
    required this.userId,
    required this.leaveRequestId,
  });

  factory AdminLeaveRequestModel.fromJson(Map<String, dynamic> doc) {
    return AdminLeaveRequestModel(
      date: doc['userId'],
      reason: doc['reason'],
      status: doc['status'],
      userId: doc['userId'],
      leaveRequestId: doc['leaveRequestId'],
    );
  }
}
