import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GenerateReportProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<List<dynamic>> rows = [];

  Future<List<List<dynamic>>> generateReport() async {
    try {
      final users = await firestore.collection("users").get();
      for (var user in users.docs) {
        final username = user['name'];
        final userId = user.id;
        final attendanceRecords = await firestore
            .collection("Attendance")
            .doc(userId)
            .collection('dates')
            .get();

        int presents = 0;
        int absents = 0;
        for (var record in attendanceRecords.docs) {
          if (record['status'] == "Present") {
            presents++;
          } else if (record['status'] == 'Absent') {
            absents++;
          }
        }
        rows.add([username, presents, absents]);
        notifyListeners();
      }
    } catch (e) {
      throw e.toString();
    }

    return rows.isNotEmpty ? rows : [];
  }
}
