import 'package:attendance_ms/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Admin
  Future<void> admin() async {
    try {
      UserCredential admin = await auth.createUserWithEmailAndPassword(
        email: "admin@gmail.com",
        password: "Admin123@",
      );
      await firestore.collection("users").doc(admin.user!.uid).set({
        'name': 'Admin',
        'email': "admin@gmail.com",
        'role': 'admin',
      });
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  //Sign Up User
  Future<void> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;

      await firestore.collection('users').doc(firebaseUser!.uid).set({
        'name': name,
        'email': email,
        'role': 'user',
      });

      _user = UserModel(
        uId: firebaseUser.uid,
        email: email,
        role: 'user',
      );
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  // Sign In User
  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;

      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(firebaseUser!.uid).get();
      _user = UserModel.fromFireStore(userDoc);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  // Sign Out User
  Future<void> signOut() async {
    await auth.signOut();
    _user = null;
    notifyListeners();
  }

  // Fetch Current User Data
  Future<void> fetchUserData() async {
    User? firebaseUser = auth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userInfo =
          await firestore.collection('users').doc(firebaseUser.uid).get();
      _user = UserModel.fromFireStore(userInfo);
    }
  }

  // Check if the user is logged in
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  /// Check if the user is an admin
  bool isAdmin() {
    return _user?.role == 'admin';
  }
}
