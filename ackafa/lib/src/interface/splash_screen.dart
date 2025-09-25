import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/services/deep_link_service.dart';
import 'package:ackaf/src/data/services/launch_url.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/screens/main_pages/approvalPages/approval_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/approvalPages/member_approval.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/paymentpage.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_registrationPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:ackaf/src/data/models/appversion_model.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/get_fcm_token.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:flutter_upgrade_version/flutter_upgrade_version.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool isAppUpdateRequired = false;
  final DeepLinkService _deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();
    // initDynamicLinks();
    checkAppVersion(context).then((_) {
      if (!isAppUpdateRequired) {
        initialize();
      }
    });
    getToken();
  }

  Future<void> checkAppVersion(context) async {
    log('Checking app version...');
    final response = await http.get(Uri.parse('$baseUrl/user/app-version'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final appVersionResponse = AppVersionResponse.fromJson(jsonResponse);

      await checkForUpdate(appVersionResponse, context);
    } else {
      log('Failed to fetch app version');
      throw Exception('Failed to load app version');
    }
  }

  Future<void> checkForUpdate(AppVersionResponse response, context) async {
    PackageInfo packageInfo = await PackageManager.getPackageInfo();
    final currentVersion = int.parse(packageInfo.version.split('.').join());
    log('Current version: $currentVersion');
    log('New version: ${response.version}');
    log('Payment enabled?: ${response.isPaymentEnabled}');
    isPaymentEnabled = response.isPaymentEnabled ?? false;
    if (currentVersion < response.version && response.force) {
      isAppUpdateRequired = true;
      showUpdateDialog(response, context);
    }
  }

  void showUpdateDialog(AppVersionResponse response, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Force update requirement
      builder: (context) => AlertDialog(
        title: Text('Update Required'),
        content: Text(response.updateMessage),
        actions: [
          TextButton(
            onPressed: () {
              // Redirect to app store
              launchURL(response.applink);
            },
            child: Text('Update Now'),
          ),
        ],
      ),
    );
  }

  Future<void> initialize() async {
    await checktoken();

    if (isAppUpdateRequired) return;

    ref.listenManual<AsyncValue<UserModel>>(userProvider, (previous, next) {
      next.when(
        data: (user) {
          if (!mounted) return;

          if (LoggedIn) {
            if (user.batch != null && user.batch != '') {
              final pendingDeepLink = _deepLinkService.pendingDeepLink;
              if (pendingDeepLink != null) {
                Navigator.pushReplacementNamed(context, '/mainpage').then((_) {
                  _deepLinkService.handleDeepLink(pendingDeepLink);
                  _deepLinkService.clearPendingDeepLink();
                }
                );
              } else {
                Navigator.pushReplacementNamed(context, '/mainpage');
              }
            } else {
              Navigator.pushReplacementNamed(context, '/userReg');
            }
          } else {
            Navigator.pushReplacementNamed(context, '/login_screen');
          }
        },
        loading: () {},
        error: (err, stack) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/login_screen');
        },
      );
    });
  }

  Future<void> checktoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedtoken = preferences.getString('token');
    String? savedId = preferences.getString('id');
    log('splashScreen: $savedtoken');
    if (savedtoken != null && savedtoken.isNotEmpty) {
      setState(() {
        LoggedIn = true;
        token = savedtoken;
        id = savedId ?? '';
      });
    }
  }

//   Future<void> initDynamicLinks() async {
//     // Handle dynamic link when the app is opened from a terminated state
//     final PendingDynamicLinkData? initialLink =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//     _handleDynamicLink(initialLink?.link);

//     // Handle dynamic link when the app is in the foreground
//     FirebaseDynamicLinks.instance.onLink
//         .listen((PendingDynamicLinkData dynamicLink) {
//       _handleDynamicLink(dynamicLink.link);
//     }).onError((error) {
//       print('onLink error: $error');
//     });
//   }

// void _handleDynamicLink(Uri? deepLink) {
//   if (deepLink != null && deepLink.path == '/notifications_page' && mounted) {
//    Navigator.pushNamed(
//   context,
//   '/home_page',
// ).then((_) {
//   Navigator.pushNamed(
//     context,
//     '/notifications_page',
//   );
// });
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 20,
            right: 0,
            left: 0,
            child: Image.asset(
              'assets/splashAkcaf.png',
              scale: 1.3,
            ),
          ),
          Positioned(
            top: 280,
            right: 0,
            left: 0,
            child: Image.asset(
              'assets/worldmap.png',
              scale: 1,
            ),
          ),
          Positioned(
            top: 530,
            right: 0,
            left: 0,
            child: Image.asset(
              'assets/splashscreenasset.png',
              scale: 1,
            ),
          ),
          const Positioned(
              top: 610,
              right: 0,
              left: 0,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'Register and join a ',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        'community of 10,000+',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        'Keralites across the',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        ' world',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ))),

          if (LoggedIn == false)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: customButton(
                label: "LET'S GET STARTED",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login_screen');
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => PaymentConfirmationPage(),
                  //     ));
                },
              ),
            ),

          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: Image.asset(
          //     'assets/splash2.png',
          //     scale: 1,
          //   ),
          // ),
          // Center(
          //   child: Image.asset(
          //     'assets/splashAkcaf.png',
          //     scale: 1.2,
          //   ),
          // ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   child: Image.asset(
          //     'assets/splash1.png',
          //     scale: 1,
          //   ),
          // ),
        ],
      ),
    );
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Initialize in your main function
void initializeNotifications() {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      String? payload = response.payload;
      log('payload = $payload');
      if (payload != null && payload.isNotEmpty && payload != ' ') {
        launchURL(payload);
      }
    },
  );
}
