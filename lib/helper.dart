import 'package:flutter/material.dart';

class Helper {
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