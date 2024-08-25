import 'package:attendance_ms/Providers/User/attendance_provider.dart';
import 'package:attendance_ms/Providers/User/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAttendanceScreen extends StatelessWidget {
  const ViewAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final attendance = Provider.of<AttendanceProvider>(context, listen: false);
    final userId = auth.user!.uId;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "View Attendance Records",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: FutureBuilder(
          future: attendance.getAttendanceRecords(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.lightBlue,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.error}"),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No Attendance Record Found"),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final record = snapshot.data![index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.lightBlue)),
                            Text(
                              "Status",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.lightBlue),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text(record.date),
                        trailing:
                            Text(record.status, style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
