import 'package:attendance_ms/Model/attendance_model.dart';
import 'package:attendance_ms/Providers/Admin/admin_attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAttendanceScreen extends StatelessWidget {
  final String userId;
  final String name;
  const UserAttendanceScreen({
    super.key,
    required this.userId,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final attendance =
        Provider.of<AdminAttendanceProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(name,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<AttendanceModel>>(
        future: attendance.fetchUserAttendance(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No Data Present at This Time"),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.hasError.toString()),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(
                          borderRadius: BorderRadius.circular(15)),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                      },
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              shape: BoxShape.rectangle,
                              backgroundBlendMode: BlendMode.difference),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Data",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Status",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...data!.map((attendanceRecord) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    attendanceRecord.date,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    attendanceRecord.status,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            );
            // return ListView.builder(
            //   itemCount: data!.length,
            //   itemBuilder: (context, index) {
            //     return Table(
            //       border: TableBorder.all(),
            //       columnWidths: const {
            //         0: FlexColumnWidth(2),
            //         1: FlexColumnWidth(2),
            //       },
            //       children: [
            //         const TableRow(
            //           children: [
            //             TableCell(
            //               child: Text("Data"),
            //             ),
            //             TableCell(
            //               child: Text("Status"),
            //             ),
            //           ],
            //         ),
            //         ...data.map((attendanceRecord) {
            //           return TableRow(
            //             children: [
            //               TableCell(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Text(attendanceRecord.date),
            //                 ),
            //               ),
            //               TableCell(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Text(attendanceRecord.status),
            //                 ),
            //               ),
            //             ],
            //           );
            //         }),
            //       ],
            //     );
            //   },
            // );
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
