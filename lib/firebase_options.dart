// lib/firebase_options.dart
// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return web; // or macOS specific if you add it
      case TargetPlatform.windows:
        return web; // or windows specific if you add it
      case TargetPlatform.linux:
        return web; // or linux specific if you add it
      case TargetPlatform.fuchsia:
        return web; // fallback
    }
  }

  // Web
  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyDo1Av53N0DJih3qfcpPtsh5AkKYYgF_WY",
      authDomain: "geofence-e5141.firebaseapp.com",
      databaseURL: "https://geofence-e5141-default-rtdb.firebaseio.com",
      projectId: "geofence-e5141",
      storageBucket: "geofence-e5141.firebasestorage.app",
      messagingSenderId: "592309591142",
      appId: "1:592309591142:web:f3488257e97f6be1b1e1a7",
      measurementId: "G-6N4W7VVJGB"
  );

  // Fill these with your real values or keep what you already had
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: '1:592309591142:android:66ae2f840fdad833b1e1a7',
    messagingSenderId: '592309591142',
    projectId: 'geofence-e5141',
    storageBucket: 'geofence-e5141.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:592309591142:ios:02ba8dafa57ba50cb1e1a7',
    messagingSenderId: '592309591142',
    projectId: 'geofence-e5141',
    storageBucket: 'geofence-e5141.appspot.com',
    iosBundleId: 'YOUR_IOS_BUNDLE_ID',
  );
}
