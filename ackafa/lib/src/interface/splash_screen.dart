import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await checktoken();
    Timer(Duration(seconds: 2), () {
      print('logged in : $LoggedIn');
      if (LoggedIn) {
        Navigator.pushReplacementNamed(context, '/mainpage');
      } else {
        Navigator.pushReplacementNamed(context, '/login_screen');
      }
    });
  }

  Future<void> checktoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedtoken = preferences.getString('token');
    String? savedId = preferences.getString('id');
    if (savedtoken != null && savedtoken.isNotEmpty && savedId!=null) {
      setState(() {
        LoggedIn = true;
        token = savedtoken;
        id = savedId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/icons/kssiaLogo.png',
          scale: 0.5,
        ),
      ),
    );
  }
}
