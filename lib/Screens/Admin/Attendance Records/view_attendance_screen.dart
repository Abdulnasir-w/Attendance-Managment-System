import 'package:attendance_ms/Providers/Admin/admin_attendance_provider.dart';
import 'package:attendance_ms/Screens/Admin/Attendance%20Records/user_attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Components/custom_tiles.dart';

class ViewAttandanceScreen extends StatelessWidget {
  const ViewAttandanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendace =
        Provider.of<AdminAttendanceProvider>(context, listen: false);
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: attendace.fetchAllUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No Data Present This Time"),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.hasError}"),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15),
                    child: Tiles(
                        title: data[index]['name'],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserAttendanceScreen(
                                userId: data[index]['id'],
                                name: data[index]['name'],
                              ),
                            ),
                          );
                        }),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("An Error Occured"),
              );
            }
          }),
    );
  }
}
