import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Components/approve_cancel_buttons.dart';
import '../../../Providers/Admin/admin_leave_request_provider.dart';

class ApproveRejectRequestScreen extends StatefulWidget {
  final String leaveRequestId;
  final String userId;
  const ApproveRejectRequestScreen({
    super.key,
    required this.leaveRequestId,
    required this.userId,
  });

  @override
  State<ApproveRejectRequestScreen> createState() =>
      _ApproveRejectRequestScreenState();
}

class _ApproveRejectRequestScreenState
    extends State<ApproveRejectRequestScreen> {
  bool isApproveLoading = false;
  bool isCancelLoading = false;
  Future<void> request(String status) async {
    final approveOrReject =
        Provider.of<AdminLeaveRequestProvider>(context, listen: false);

    try {
      setState(() {
        if (status == "Approved") {
          isApproveLoading = true;
        } else if (status == "Rejected") {
          isCancelLoading = true;
        }
      });

      await approveOrReject.updateStatus(
          widget.userId, widget.leaveRequestId, status);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        isApproveLoading = false;
        isCancelLoading = false;
      });
      throw e.toString();
    } finally {
      setState(() {
        isApproveLoading = false;
        isCancelLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ApproveButtons(
          title: "Approve",
          textColor: Colors.white,
          icon: Icons.check_circle,
          isLoading: isApproveLoading,
          onPressed: () async {
            await request("Approved");
          },
          btnColor: Colors.green,
        ),
        ApproveButtons(
          title: "Cancel",
          textColor: Colors.white,
          isLoading: isCancelLoading,
          icon: Icons.cancel,
          onPressed: () async {
            await request("Rejected");
          },
          btnColor: Colors.red,
        ),
      ],
    );
  }
}
