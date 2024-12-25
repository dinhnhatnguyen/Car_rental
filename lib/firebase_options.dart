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
    apiKey: 'AIzaSyAKk-FVi2-nwJOChSx2GT3xl4kOYpBaHRg',
    appId: '1:1055727481758:web:002438e1e58db4d8671c8f',
    messagingSenderId: '1055727481758',
    projectId: 'carrental-2ce8d',
    authDomain: 'carrental-2ce8d.firebaseapp.com',
    storageBucket: 'carrental-2ce8d.firebasestorage.app',
    measurementId: 'G-1Q1P29NVJG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCXOSiVTLMUqCXMNile_o9HF6BsGH3zJBc',
    appId: '1:1055727481758:android:1cf2c762af23dcb5671c8f',
    messagingSenderId: '1055727481758',
    projectId: 'carrental-2ce8d',
    storageBucket: 'carrental-2ce8d.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCXd_G55SlwtqapEPYM8WAbCipxPv77A6g',
    appId: '1:1055727481758:ios:5a26c584f69374ea671c8f',
    messagingSenderId: '1055727481758',
    projectId: 'carrental-2ce8d',
    storageBucket: 'carrental-2ce8d.firebasestorage.app',
    iosBundleId: 'com.nhatnguyen.carRental',
  );
}
