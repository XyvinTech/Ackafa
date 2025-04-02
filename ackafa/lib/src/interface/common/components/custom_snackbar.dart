import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.white),
          SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Colors.green,
      behavior:
          SnackBarBehavior.floating, // Makes the Snackbar float above the UI
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(16), // Adds margin to make it more aesthetic
      duration: Duration(seconds: 4), // Duration the Snackbar is visible
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: Colors.white,
        onPressed: () {
          // Do something when the action is clicked, if needed
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
