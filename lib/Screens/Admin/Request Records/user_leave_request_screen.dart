import 'package:attendance_ms/Providers/Admin/admin_leave_request_provider.dart';
import 'package:attendance_ms/Screens/Admin/Request%20Records/view_user_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Components/custom_tiles.dart';

class UserLeaveRequestScreen extends StatelessWidget {
  const UserLeaveRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaveRequest =
        Provider.of<AdminLeaveRequestProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Leave Requests",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: leaveRequest.fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (leaveRequest.users.isEmpty) {
            return const Center(
              child: Text("No leave requests found."),
            );
          } else if (leaveRequest.users.isNotEmpty) {
            return ListView.builder(
              itemCount: leaveRequest.users.length,
              itemBuilder: (context, index) {
                final user = leaveRequest.users[index];
                final id = user['id'];
                final userName = user['name'];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Tiles(
                    title: userName,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewUserRequestScreen(
                            title: userName,
                            id: id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("An Error Occured Please Try Again Later."),
            );
          }
        },
      ),
    );
  }
}
