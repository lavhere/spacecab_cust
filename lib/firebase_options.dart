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
    apiKey: 'AIzaSyChkT70C2jPLA-R2EwW4UTrdkEimZTOWiA',
    appId: '1:181065496815:web:37f05cc510d28d75f9431a',
    messagingSenderId: '181065496815',
    projectId: 'spacecab-b451e',
    authDomain: 'spacecab-b451e.firebaseapp.com',
    storageBucket: 'spacecab-b451e.firebasestorage.app',
    measurementId: 'G-TK6B7XFWFH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2pJFaXINsPGeuyQDj__pAbITmZILGiSA',
    appId: '1:181065496815:android:2e671048b46f8924f9431a',
    messagingSenderId: '181065496815',
    projectId: 'spacecab-b451e',
    storageBucket: 'spacecab-b451e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNtsGu6S-is9wEQWDnW34BsmQGdrwwTOw',
    appId: '1:181065496815:ios:7b4aaa52a670a545f9431a',
    messagingSenderId: '181065496815',
    projectId: 'spacecab-b451e',
    storageBucket: 'spacecab-b451e.firebasestorage.app',
    iosBundleId: 'com.example.spacecab',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDNtsGu6S-is9wEQWDnW34BsmQGdrwwTOw',
    appId: '1:181065496815:ios:7b4aaa52a670a545f9431a',
    messagingSenderId: '181065496815',
    projectId: 'spacecab-b451e',
    storageBucket: 'spacecab-b451e.firebasestorage.app',
    iosBundleId: 'com.example.spacecab',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyChkT70C2jPLA-R2EwW4UTrdkEimZTOWiA',
    appId: '1:181065496815:web:547472a1a109acddf9431a',
    messagingSenderId: '181065496815',
    projectId: 'spacecab-b451e',
    authDomain: 'spacecab-b451e.firebaseapp.com',
    storageBucket: 'spacecab-b451e.firebasestorage.app',
    measurementId: 'G-FHVHYWMJVB',
  );
}
