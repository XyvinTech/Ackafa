import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserInactivePage extends StatelessWidget {
  const UserInactivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.hexagonDots(
              color: const Color(0xFFE30613),
              size: 80,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Your request to join has been sent',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Access to the app will be made',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const Text(
              'available to you soon',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const Text(
              'Thank you for your patience',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            )
          ],
        ));
  }
}
