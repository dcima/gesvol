import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Helper {
  // globals objects
  static GoogleSignInAccount? currentUser;
  static var primary = Colors.blue;
  static GoogleSignIn googleObj = GoogleSignIn();

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