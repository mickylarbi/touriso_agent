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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBLWZ0waPuUdDK5tN6UQ19659IO5RDoRGw',
    appId: '1:437881507377:web:d568fc4e2921dc02574f10',
    messagingSenderId: '437881507377',
    projectId: 'touriso-ea0',
    authDomain: 'touriso-ea0.firebaseapp.com',
    storageBucket: 'touriso-ea0.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZMMwvbAFaUYzz95AInWEnWdR66t5LeV8',
    appId: '1:437881507377:ios:84e19cd67c6348c9574f10',
    messagingSenderId: '437881507377',
    projectId: 'touriso-ea0',
    storageBucket: 'touriso-ea0.appspot.com',
    iosClientId: '437881507377-bamqvadh51tuegceqqjcklcq4skbpmpe.apps.googleusercontent.com',
    iosBundleId: 'com.example.tourisoAgent.RunnerTests',
  );
}
