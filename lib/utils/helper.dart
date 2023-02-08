import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Helper {
  // globals objects
  static User? userFirebase;
  static User? userGoogle;
  static GoogleSignIn? googleSignIn;
  static var authClient;

  Helper._();

  static snackMsg(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: (Colors.red),
      ),
    );
  }
}