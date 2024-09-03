// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAd0H7BlN_lHHbOIPKt_sp-s5_FpWYVTlA',
    appId: '1:1085720545332:web:2ec33488b6e7a6e3166261',
    messagingSenderId: '1085720545332',
    projectId: 'ackaf-9318f',
    authDomain: 'ackaf-9318f.firebaseapp.com',
    storageBucket: 'ackaf-9318f.appspot.com',
    measurementId: 'G-ZN4RBR4BWQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjIqtCCm-0HyQgk1fHx4XLb1sz8YGjj7A',
    appId: '1:1085720545332:android:8455b668f589b2de166261',
    messagingSenderId: '1085720545332',
    projectId: 'ackaf-9318f',
    storageBucket: 'ackaf-9318f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkKMDpYwb1Nq1_Zn1MN0IpDDfdweju9ks',
    appId: '1:1085720545332:ios:ed4e498b9b3643f5166261',
    messagingSenderId: '1085720545332',
    projectId: 'ackaf-9318f',
    storageBucket: 'ackaf-9318f.appspot.com',
    iosBundleId: 'com.example.ackaf',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAkKMDpYwb1Nq1_Zn1MN0IpDDfdweju9ks',
    appId: '1:1085720545332:ios:ed4e498b9b3643f5166261',
    messagingSenderId: '1085720545332',
    projectId: 'ackaf-9318f',
    storageBucket: 'ackaf-9318f.appspot.com',
    iosBundleId: 'com.example.ackaf',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAd0H7BlN_lHHbOIPKt_sp-s5_FpWYVTlA',
    appId: '1:1085720545332:web:cc4a7d6a4b5e5145166261',
    messagingSenderId: '1085720545332',
    projectId: 'ackaf-9318f',
    authDomain: 'ackaf-9318f.firebaseapp.com',
    storageBucket: 'ackaf-9318f.appspot.com',
    measurementId: 'G-TBH07XN29N',
  );
}
