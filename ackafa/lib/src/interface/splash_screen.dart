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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // initDynamicLinks();
    checkAppVersion(context).then((_) {
      if (!isAppUpdateRequired) {
        initialize();
      }
    });
    getToken(context);
  }

  Future<void> checkAppVersion(context) async {
    log('Checking app version...');
    final response = await http.get(Uri.parse('$baseUrl/user/app-version'));
    log(response.body.toString());
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

  bool _isNavigated = false;

  Future<void> initialize() async {
    await checktoken();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }

    if (isAppUpdateRequired) return;

    ref.listenManual<AsyncValue<UserModel>>(userProvider, (previous, next) {
      if (_isNavigated) return; // Prevent infinite push loops during transition
      next.when(
        data: (user) {
          if (!mounted) return;

          if (LoggedIn) {
            _isNavigated = true;
            if (user.batch != null && user.batch != '') {
              final pendingDeepLink = _deepLinkService.pendingDeepLink;
              if (pendingDeepLink != null) {
                Navigator.pushReplacementNamed(context, '/mainpage').then((_) {
                  _deepLinkService.handleDeepLink(pendingDeepLink);
                  _deepLinkService.clearPendingDeepLink();
                });
              } else {
                Navigator.pushReplacementNamed(context, '/mainpage');
              }
            } else {
              _isNavigated = true;
              Navigator.pushReplacementNamed(context, '/userReg');
            }
          }
        },
        loading: () {},
        error: (err, stack) {},
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
    final showOnboarding = _isInitialized && !LoggedIn;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: showOnboarding
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: showOnboarding
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                if (!showOnboarding) const Spacer(),
                Image.asset(
                  'assets/splashAkcaf.png',
                  width: showOnboarding ? 120 : 180,
                ),
                if (!showOnboarding) ...[
                  const SizedBox(height: 32),
                  const CircularProgressIndicator(color: Color(0xFFE30613)),
                  const Spacer(),
                ],
                if (showOnboarding) ...[
                  const Spacer(),
                  const Text(
                    'Join 10,000+ Keralites,\nwherever you are',
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Connect with your community, follow local events, and stay rooted -- whether you\'re in Kochi or Dubai.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  customButton(
                    label: 'Get started',
                    radius: 12,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login_screen');
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
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
  const DarwinInitializationSettings iosInitializationSetting =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const InitializationSettings initSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: iosInitializationSetting);
  flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      String? payload = response.payload;
      log('payload = $payload');
      if (payload != null && payload.isNotEmpty && payload != ' ') {
        launchURL(payload);
      }
    },
  );
}
