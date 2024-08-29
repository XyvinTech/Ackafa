import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String assetName;
  final double size;
  final Color? color;

  const SvgIcon({
    required this.assetName,
    this.size = 0.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      color: color,
      fit: BoxFit
          .scaleDown, // This forces the SVG to scale down within the given size
    );
  }
}
