import 'package:attendance_ms/Model/admin_leave_model.dart';
import 'package:attendance_ms/Providers/Admin/admin_leave_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Components/custom_tiles.dart';

class ManageLeaveRequestScreen extends StatelessWidget {
  const ManageLeaveRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaveRequest =
        Provider.of<AdminLeaveRequestProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage Leave Requests",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<String>>(
        future: leaveRequest.fetchAllUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No Data is Present at This Time"),
            );
          } else {
            final data = snapshot.data!;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final user = data[index];

                return Tiles(
                  onPressed: () {},
                  title: user,
                );
              },
            );
          }
        },
      ),
    );
  }
}
