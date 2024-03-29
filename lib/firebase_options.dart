// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBUBEfO4Aq6WQVucBIoCiBsdvJGcxkfsSg',
    appId: '1:634262095096:web:1842f4f7cdd774821c270d',
    messagingSenderId: '634262095096',
    projectId: 'saathi-e00e0',
    authDomain: 'saathi-e00e0.firebaseapp.com',
    storageBucket: 'saathi-e00e0.appspot.com',
    measurementId: 'G-NYKVEFWEST',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvvFqFTfeSOAtdYcOg0xrgFRQ-0NCco48',
    appId: '1:634262095096:android:0d1d6212f6e06a281c270d',
    messagingSenderId: '634262095096',
    projectId: 'saathi-e00e0',
    storageBucket: 'saathi-e00e0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCnMSTRg3mGkFQJwaoPUX6eGQ4_YJQ1PPM',
    appId: '1:634262095096:ios:e1d5bad32c4d48b31c270d',
    messagingSenderId: '634262095096',
    projectId: 'saathi-e00e0',
    storageBucket: 'saathi-e00e0.appspot.com',
    iosBundleId: 'com.example.saathi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCnMSTRg3mGkFQJwaoPUX6eGQ4_YJQ1PPM',
    appId: '1:634262095096:ios:3f68e30291372dc21c270d',
    messagingSenderId: '634262095096',
    projectId: 'saathi-e00e0',
    storageBucket: 'saathi-e00e0.appspot.com',
    iosBundleId: 'com.example.saathi.RunnerTests',
  );
}
