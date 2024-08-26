import 'package:attendance_ms/Providers/User/auth_provider.dart';
import 'package:attendance_ms/Providers/User/leave_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckRequestScreen extends StatelessWidget {
  const CheckRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaveRequest =
        Provider.of<LeaveRequestProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Check Request Rejected or Approved",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: FutureBuilder(
            future: leaveRequest.getLeaveRequest(auth.user!.uId),
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
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.lightBlue),
                            ),
                            Text(
                              "Status",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.lightBlue),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final record = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: Text(record.date),
                              trailing: Text(
                                record.status,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
