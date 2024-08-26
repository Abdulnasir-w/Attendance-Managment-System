import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAttendanceProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAllUser() async {
    try {
      final user = await firestore.collection('users').get();
      return user.docs
          .map((docs) => {"id": docs.id, "name": docs['name']})
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }
}
