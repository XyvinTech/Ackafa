import 'package:ackaf/src/data/globals.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for iOS devices (optional)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // Fetch the FCM token
    await Future.delayed(Duration(seconds: 10));
    String? token = await messaging.getToken();
    fcmToken = token!;
    print("FCM Token: $token");
  } else {
    print('User declined or has not accepted permission');
  }
}
