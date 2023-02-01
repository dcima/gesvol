import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Helper {
  // globals objects
  static User? userFirebase;
  static User? userGoogle;

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