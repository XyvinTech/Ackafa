
import 'package:ackaf/firebase_options.dart';
import 'package:ackaf/src/data/models/chat_model.dart';
import 'package:ackaf/src/data/models/events_model.dart';
import 'package:ackaf/src/data/services/deep_link_service.dart';
import 'package:ackaf/src/data/services/notification_service.dart';
import 'package:ackaf/src/interface/screens/event_news/viewmore_event.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/profile_completetion_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_registrationPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/people_page.dart';
import 'package:ackaf/src/interface/screens/menu/my_events.dart';
import 'package:ackaf/src/interface/screens/menu/my_post.dart';
import 'package:ackaf/src/interface/screens/menu/my_subscriptions.dart';
import 'package:ackaf/src/interface/screens/people/chat/chat.dart';
import 'package:ackaf/src/interface/screens/people/chat/chatscreen.dart';
import 'package:ackaf/src/interface/screens/people/chat/groupchat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/interface/screens/main_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPage.dart';
import 'package:ackaf/src/interface/splash_screen.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeNotifications();
  await NotificationService().initialize();
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
   
      navigatorKey: navigatorKey,
   

        initialRoute: '/',
      routes: {
        '/': (context) {
          // Initialize deep linking
          DeepLinkService().initialize(context);
          return SplashScreen();
        },
 
        '/mainpage': (context) => MainPage(),
        '/splash': (context) => SplashScreen(),
        '/profile_completion': (context) => ProfileCompletionScreen(),
        '/my_feeds': (context) => MyPostsPage(),
'/userReg': (context) => const UserRegistrationScreen(),
        '/notification': (context) => NotificationPage(),
        '/my_subscription': (context) => MySubscriptionPage(),
        '/chat': (context) => PeoplePage(
        
            ),
        // '/membership': (context) => MembershipSubscription(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/individual_page') {
          final args = settings.arguments as Map<String, dynamic>?;
          Participant sender = args?['sender'];
          Participant receiver = args?['receiver'];

          return MaterialPageRoute(
            builder: (context) => IndividualPage(
              receiver: receiver,
              sender: sender,
            ),
          );
        } else if (settings.name == '/event_details') {
      
          Event event = settings.arguments as Event;

          return MaterialPageRoute(
            builder: (context) => ViewMoreEventPage(
              event: event,
            ),
          );
        }

        return null;
      },
    );
  }
}

// Initialize in your main function

