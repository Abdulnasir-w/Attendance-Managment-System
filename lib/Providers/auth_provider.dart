import 'dart:io';

import 'package:attendance_ms/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  late BuildContext context;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  //Sign Up User
  Future<void> signUp(String name, String email, String password) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the newly created user
      User? firebaseUser = userCredential.user;

      // Check if the user is not null
      if (firebaseUser != null) {
        // Save additional user information in Firestore
        await firestore.collection('users').doc(firebaseUser.uid).set({
          'name': name,
          'email': email,
          'role': 'user',
          'profilePicUrl': null,
        });

        // Update local user model
        _user = UserModel(
          uId: firebaseUser.uid,
          email: email,
          name: name,
          role: 'user',
          profilePicUrl: null,
        );
        notifyListeners();
      } else {
        throw Exception('Failed to create user');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
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
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
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

  // Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e);
    }
  }

  // Fetch Current User Data
  Future<void> fetchUserData() async {
    User? firebaseUser = auth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userInfo;
      if (firebaseUser.email == 'admin@gmail.com') {
        userInfo = await firestore.collection('users').doc('admin').get();
      } else {
        userInfo =
            await firestore.collection('users').doc(firebaseUser.uid).get();
      }
      if (userInfo.exists) {
        _user = UserModel(
          email: userInfo['email'],
          role: userInfo['role'],
          name: userInfo['name'],
          profilePicUrl: userInfo['profilePicUrl'] ?? "",
          uId: firebaseUser.uid,
        );
        notifyListeners();
      } else {
        _user = UserModel(
          uId: '',
          email: '',
          name: '',
          role: '',
          profilePicUrl: '',
        );
      }
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

  // Profile Pic
  Future<void> uploadPictoFirebaseStorage(String filePath) async {
    try {
      User? firebaseUser = auth.currentUser;
      if (firebaseUser == null) return;

      final extension = filePath.split('.').last;
      final storageRef = storage
          .ref()
          .child("Profile Picture/${firebaseUser.displayName}.$extension");

      final uploadPic = storageRef.putFile(File(filePath));
      await uploadPic;

      final downloadUrl = await storageRef.getDownloadURL();
      await firestore.collection("users").doc(firebaseUser.uid).update({
        'profilePicUrl': downloadUrl,
      });

      _user = UserModel(
        email: _user!.email,
        role: _user!.role,
        uId: _user!.uId,
        name: _user!.name,
        profilePicUrl: downloadUrl,
      );
      notifyListeners();
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }
}
