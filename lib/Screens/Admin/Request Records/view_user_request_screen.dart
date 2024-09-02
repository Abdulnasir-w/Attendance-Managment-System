import 'package:attendance_ms/Model/admin_leave_model.dart';
import 'package:attendance_ms/Providers/Admin/admin_leave_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'approve_reject_request_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    print("BUild");
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
                        ApproveRejectRequestScreen(
                          leaveRequestId: request.leaveRequestId,
                          userId: widget.id,
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
