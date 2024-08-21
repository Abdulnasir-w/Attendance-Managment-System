import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uId;
  final String email;
  final String? name;
  final String role;
  final String? profilePicUrl;

  UserModel({
    this.name,
    this.profilePicUrl,
    required this.uId,
    required this.email,
    required this.role,
  });
  factory UserModel.fromFireStore(DocumentSnapshot doc) {
    if (doc.exists || doc.data() == null) {
      return UserModel(
        uId: "",
        email: "",
        role: "",
        name: "",
      );
    }
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uId: doc.id,
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      role: data['role'] ?? "",
      profilePicUrl: data['profilePicUrl'] ?? "",
    );
  }
}
