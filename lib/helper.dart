import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Helper {
  // globals objects
  static GoogleSignInAccount? currentUser = null;
  static var primary = Colors.blue;

  Helper._();

  static snackMsg(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$message"),
        backgroundColor: (Colors.red),
      ),
    );
  }
}