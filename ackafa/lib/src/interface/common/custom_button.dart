import 'package:flutter/material.dart';

Widget customButton(
    {required String label,
    required VoidCallback onPressed,
    required int fontSize}) {
  return SizedBox(
    height: 55,
    width: double.infinity,
    child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(Color(0xFFE30613)),
          backgroundColor: WidgetStateProperty.all<Color>(Color(0xFFE30613)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: BorderSide(color: Color(0xFFE30613)),
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: Colors.white, fontSize: double.parse(fontSize.toString())),
        )),
  );
}
