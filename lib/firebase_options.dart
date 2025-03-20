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
    apiKey: 'AIzaSyDVGzAqkwZcxsI6TwRXV_lDBvrdJ3z2wLc',
    appId: '1:5314711456:web:16b125d23ba52f68ee5ec5',
    messagingSenderId: '5314711456',
    projectId: 'chatee24fyp',
    authDomain: 'chatee24fyp.firebaseapp.com',
    storageBucket: 'chatee24fyp.firebasestorage.app',
    measurementId: 'G-B04TKSCCT3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUnVZl7bPnICndZEEkPkk98Y57zDk0uwY',
    appId: '1:559444074636:android:d43cac72f8a1b56dbf1ba9',
    messagingSenderId: '559444074636',
    projectId: 'medichat-a2965',
    storageBucket: 'medichat-a2965.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARrvbTYlTJvUymlTOFJg4ndKBiQY8UleA',
    appId: '1:5314711456:ios:0fcf2e75cd815270ee5ec5',
    messagingSenderId: '5314711456',
    projectId: 'chatee24fyp',
    storageBucket: 'chatee24fyp.firebasestorage.app',
    iosBundleId: 'com.example.medichat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyARrvbTYlTJvUymlTOFJg4ndKBiQY8UleA',
    appId: '1:5314711456:ios:0fcf2e75cd815270ee5ec5',
    messagingSenderId: '5314711456',
    projectId: 'chatee24fyp',
    storageBucket: 'chatee24fyp.firebasestorage.app',
    iosBundleId: 'com.example.medichat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDVGzAqkwZcxsI6TwRXV_lDBvrdJ3z2wLc',
    appId: '1:5314711456:web:1b7b8ffe9e89a7c6ee5ec5',
    messagingSenderId: '5314711456',
    projectId: 'chatee24fyp',
    authDomain: 'chatee24fyp.firebaseapp.com',
    storageBucket: 'chatee24fyp.firebasestorage.app',
    measurementId: 'G-MPZJSDG0C5',
  );
}