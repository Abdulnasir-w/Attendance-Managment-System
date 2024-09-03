import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class GenerateReportProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> generateReport() async {
    try {
      final users = await firestore.collection("users").get();
      List<List<dynamic>> rows = [];
      rows.add(['User Id', "Present", "Absent"]);

      for (var user in users.docs) {
        final userId = user.id;
        final attendanceRecords = await firestore
            .collection("Attendance")
            .doc(userId)
            .collection('dates')
            .get();

        int presents = 0;
        int absents = 0;

        for (var records in attendanceRecords.docs) {
          if (records['status'] == "Present") {
            presents++;
          } else if (records['status'] == 'Absent') {
            absents++;
          }
          rows.add([userId, presents, absents]);
        }
        String csvData = const ListToCsvConverter().convert(rows);
        final directory = await getApplicationDocumentsDirectory();
        final path = "${directory.path}/report.csv";
        final file = File(path);
        await file.writeAsString(csvData);
        Share.share(file.path, subject: "Attendance Report");
        print("path :: $path");
        notifyListeners();
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
