import 'dart:async';
import 'dart:developer';

import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/api_routes/app_versioncheck_api.dart';
import 'package:ackaf/src/data/services/get_fcm_token.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/globals.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAppVersion(context);
    initialize();
    getToken();
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("New FCM Token: $newToken");
      // Save or send the new token to your server
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in foreground: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened: ${message.data}');
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('Notification clicked when app was terminated');
      }
    });
  }

  Future<void> initialize() async {
    await checktoken();
    Timer(Duration(seconds: 2), () {
      print('logged in : $LoggedIn');
      if (LoggedIn) {
        ref.invalidate(userProvider);
        Navigator.pushReplacementNamed(context, '/userReg');
      } else {
        Navigator.pushReplacementNamed(context, '/login_screen');
      }
    });
  }

  Future<void> checktoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedtoken = preferences.getString('token');
    String? savedId = preferences.getString('id');
    isAgreed = false;
    log('splashScreen: $savedtoken');
    if (savedtoken != null && savedtoken.isNotEmpty) {
      setState(() {
        LoggedIn = true;
        token = savedtoken;
        id = savedId ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/splash2.png',
              scale: 1,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/icons/akcaf_icon.png',
              scale: 1.2,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/splash1.png',
              scale: 1,
            ),
          ),
        ],
      ),
    );
  }
}
