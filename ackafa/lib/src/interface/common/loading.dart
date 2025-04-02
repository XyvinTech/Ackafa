import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.hexagonDots(
      color: Color(0xFFE30613),
      size: 30,
    );
  }
}
