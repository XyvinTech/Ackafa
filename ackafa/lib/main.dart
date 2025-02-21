
import 'package:ackaf/firebase_options.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_registrationPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:ackaf/src/interface/screens/menu/my_events.dart';
import 'package:ackaf/src/interface/screens/menu/my_post.dart';
import 'package:ackaf/src/interface/screens/people/chat/chat.dart';
import 'package:ackaf/src/interface/screens/people/chat/groupchat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/interface/screens/main_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPage.dart';
import 'package:ackaf/src/interface/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeNotifications();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
} 

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          bodyMedium: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          displayLarge:
              TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          displayMedium:
              TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          displaySmall:
              TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          headlineMedium:
              TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          headlineSmall:
              TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          titleLarge: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          titleMedium: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          titleSmall: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          labelLarge: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          labelMedium: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          labelSmall: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
          bodySmall: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4647)),
        ),
        primarySwatch: Colors.blue,
        secondaryHeaderColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login_screen': (context) => LoginPage(),
        '/userReg': (context) => const UserRegistrationScreen(),
        '/notifications_page': (context) => NotificationPage(),
        '/my_events': (context) => MyEventsPage(),
        '/main_page': (context) => MainPage(),
        '/my_posts': (context) => MyPostsPage(),
        '/chat_page': (context) => ChatPage(),
        '/group_chat_page': (context) => GroupChatPage(),
      },
    );
  }
}

// Initialize in your main function

