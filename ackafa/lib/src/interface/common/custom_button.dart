import 'package:flutter/material.dart';

Widget customButton({
  required String label,
  required VoidCallback onPressed,
  Color sideColor = const Color(0xFFE30613),
  Color labelColor = Colors.white,
  int fontSize = 16,
  int buttonHeight = 45,
  Color buttonColor = const Color(0xFFE30613),
}) {
  return SizedBox(
    height: buttonHeight.toDouble(),
    width: double.infinity,
    child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(buttonColor),
          backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: sideColor),
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: labelColor, fontSize: double.parse(fontSize.toString())),
        )),
  );
}
