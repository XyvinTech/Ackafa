import 'package:flutter/material.dart';

Widget customButton(
    {required String label,
    Color color = const Color(0xFFE30613),
    required VoidCallback onPressed,
    required int fontSize}) {
  return SizedBox(
    height: 55,
    width: double.infinity,
    child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(color),
          backgroundColor: WidgetStateProperty.all<Color>(color),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: BorderSide(color: color),
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
