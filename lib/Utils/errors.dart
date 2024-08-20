import 'package:firebase_auth/firebase_auth.dart';

String getCustomErrorMessage(Object e) {
  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'invalid-email':
        return "Invalid email address. Please check and try again.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'user-not-found':
        return "No account found with this email.";
      case 'user-disabled':
        return "This account has been disabled.";
      case 'too-many-requests':
        return "Too many login attempts. Please try again later.";
      case 'operation-not-allowed':
        return "This operation is not allowed. Please contact support.";
      case 'email-already-exist':
        return "The Email is Already Exist.";
      default:
        return "An unexpected error occurred. Please try again.";
    }
    // Add more specific error messages here
  }
  return "An error occurred. Please try again.";
}
