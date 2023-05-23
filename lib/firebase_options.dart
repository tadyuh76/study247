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
    apiKey: 'AIzaSyC8SAqfyBnfRM7m1BpbC3lDh4BHqERzZh8',
    appId: '1:576191297874:web:7db29abe2dbf027e0ba28b',
    messagingSenderId: '576191297874',
    projectId: 'studie-a9c68',
    authDomain: 'studie-a9c68.firebaseapp.com',
    storageBucket: 'studie-a9c68.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxjDJlxnhi8PRlp91xSsEZhzmU80Tvs3w',
    appId: '1:576191297874:android:10bfe023fb9eb6ed0ba28b',
    messagingSenderId: '576191297874',
    projectId: 'studie-a9c68',
    storageBucket: 'studie-a9c68.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTOgdmIZTMo3_9_TmuciJGxLmKvcERIMw',
    appId: '1:576191297874:ios:daa92cfce4b1a4690ba28b',
    messagingSenderId: '576191297874',
    projectId: 'studie-a9c68',
    storageBucket: 'studie-a9c68.appspot.com',
    iosClientId:
        '576191297874-pg40ptg0p0gsirivppfuvo8k7v57ka9r.apps.googleusercontent.com',
    iosBundleId: 'com.tadyuh.studie',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTOgdmIZTMo3_9_TmuciJGxLmKvcERIMw',
    appId: '1:576191297874:ios:daa92cfce4b1a4690ba28b',
    messagingSenderId: '576191297874',
    projectId: 'studie-a9c68',
    storageBucket: 'studie-a9c68.appspot.com',
    iosClientId:
        '576191297874-pg40ptg0p0gsirivppfuvo8k7v57ka9r.apps.googleusercontent.com',
    iosBundleId: 'com.tadyuh.studie',
  );
}
