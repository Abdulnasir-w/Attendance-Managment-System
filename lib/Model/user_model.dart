import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uId;
  final String email;
  final String role;

  UserModel({required this.uId, required this.email, required this.role});
  factory UserModel.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uId: doc.id,
      email: data['email'] ?? "",
      role: data['role'] ?? "",
    );
  }
}
