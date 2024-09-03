import 'package:ackaf/firebase_options.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_inactive_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/interface/screens/main_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPage.dart';
import 'package:ackaf/src/interface/splash_screen.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
     await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          secondaryHeaderColor: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => UserInactivePage(),
          '/login_screen': (context) => LoginPage(),
          '/mainpage': (context) => MainPage(),
        });
  }
}
