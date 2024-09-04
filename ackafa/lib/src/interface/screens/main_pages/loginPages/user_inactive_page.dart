import 'package:flutter/material.dart';

class UserInactivePage extends StatelessWidget {
  const UserInactivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Image.asset(scale: 1.19, 'assets/inactive.png')));
  }
}
