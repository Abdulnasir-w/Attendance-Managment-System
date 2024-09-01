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
  @override
  Widget build(BuildContext context) {
    final leave =
        Provider.of<AdminLeaveRequestProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
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
                      horizontal: 15.0, vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 400,
                        width: 400,
                        child: Card(
                          surfaceTintColor: Colors.lightBlue,
                          shadowColor: Colors.blue,
                          elevation: 5,
                          child: Text(request.reason),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ApproveButtons(
                            title: "Approve",
                            textColor: Colors.white,
                            icon: Icons.check_circle,
                          ),
                          ApproveButtons(
                            title: "Cancel",
                            textColor: Colors.white,
                            icon: Icons.cancel,
                          ),
                        ],
                      ),
                    ],
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
