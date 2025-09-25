import 'package:flutter/material.dart';

class AppTextStyles {
  // Heading (large, bold)
  static const TextStyle heading = TextStyle(
    fontFamily: 'HelveticaNeue',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Sub Heading (medium, semi-bold)
  static const TextStyle subHeading = TextStyle(
    fontFamily: 'HelveticaNeue',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Middle Size (normal text)
  static const TextStyle middle = TextStyle(
    fontFamily: 'HelveticaNeue',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );
}
