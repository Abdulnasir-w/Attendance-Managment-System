import 'package:attendance_ms/Model/admin_leave_model.dart';
import 'package:attendance_ms/Providers/Admin/admin_leave_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Components/approve_cancel_buttons.dart';

class ViewUserRequestScreen extends StatefulWidget {
  final String title;
  final String id;
  const ViewUserRequestScreen({
    super.key,
    required this.title,
    required this.id,
  });

  @override
  State<ViewUserRequestScreen> createState() => _ViewUserRequestScreenState();
}

class _ViewUserRequestScreenState extends State<ViewUserRequestScreen> {
  bool isLoading = false; // To manage loading for each request
  Future<void> requestLeave(String id, String requestId, String status) async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(milliseconds: 300));

      await Provider.of<AdminLeaveRequestProvider>(context, listen: false)
          .updateStatus(widget.id, requestId, status);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("BUilddd");
    final leave =
        Provider.of<AdminLeaveRequestProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<AdminLeaveRequestModel>>(
        future: leave.fetchUserRequest(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No Data Present at This Time"),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.hasError.toString()),
            );
          } else if (snapshot.hasData) {
            final leaveRequest = snapshot.data!;
            return ListView.builder(
              itemCount: leaveRequest.length,
              itemBuilder: (context, index) {
                final request = leaveRequest[index];
                // final isLoading =
                //     loadingStates[request.leaveRequestId] ?? false;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 550,
                          width: 400,
                          child: Card(
                            color: Colors.grey[50],
                            elevation: 5,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  request.date,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  request.reason,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ApproveButtons(
                              title: "Approve",
                              textColor: Colors.white,
                              icon: Icons.check_circle,
                              isLoading: isLoading,
                              onPressed: () async {
                                requestLeave(widget.id, request.leaveRequestId,
                                    "Approved");
                              },
                              btnColor: Colors.green,
                            ),
                            ApproveButtons(
                              title: "Cancel",
                              textColor: Colors.white,
                              isLoading: isLoading,
                              icon: Icons.cancel,
                              onPressed: () async {
                                await Future.delayed(
                                    Duration(milliseconds: 300));
                                requestLeave(widget.id, request.leaveRequestId,
                                    "Reject");
                              },
                              btnColor: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("An Error Occured Please Try Again Later!"),
            );
          }
        },
      ),
    );
  }
}
