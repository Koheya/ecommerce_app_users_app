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
    apiKey: 'AIzaSyALUgPGpOcrIJgNejYRgNFT1vFdrSEUxLI',
    appId: '1:1047896275225:web:90d3b35d8e681ecaf8ad88',
    messagingSenderId: '1047896275225',
    projectId: 'shopsmartar-db44f',
    authDomain: 'shopsmartar-db44f.firebaseapp.com',
    storageBucket: 'shopsmartar-db44f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAulr7U3nEiWACcl_E5U2PW-T7qvnFfHTI',
    appId: '1:1047896275225:android:212d9bd2349dc28af8ad88',
    messagingSenderId: '1047896275225',
    projectId: 'shopsmartar-db44f',
    storageBucket: 'shopsmartar-db44f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCij8BJWX4kipCtMEd1-XP4s6OQGZQEemE',
    appId: '1:1047896275225:ios:f4ee99fa43ca7b7ff8ad88',
    messagingSenderId: '1047896275225',
    projectId: 'shopsmartar-db44f',
    storageBucket: 'shopsmartar-db44f.appspot.com',
    iosBundleId: 'com.example.ecommerce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCij8BJWX4kipCtMEd1-XP4s6OQGZQEemE',
    appId: '1:1047896275225:ios:f4ee99fa43ca7b7ff8ad88',
    messagingSenderId: '1047896275225',
    projectId: 'shopsmartar-db44f',
    storageBucket: 'shopsmartar-db44f.appspot.com',
    iosBundleId: 'com.example.ecommerce',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyALUgPGpOcrIJgNejYRgNFT1vFdrSEUxLI',
    appId: '1:1047896275225:web:9a87f43e27cf58bcf8ad88',
    messagingSenderId: '1047896275225',
    projectId: 'shopsmartar-db44f',
    authDomain: 'shopsmartar-db44f.firebaseapp.com',
    storageBucket: 'shopsmartar-db44f.appspot.com',
  );
}
