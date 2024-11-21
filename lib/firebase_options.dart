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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBvDmpqRcXhCNGKnGIsznKlCwFA8U7DLMk',
    appId: '1:208511786964:web:861b6cbdb6ac5a29a7c041',
    messagingSenderId: '208511786964',
    projectId: 'social-media-app-b5ea5',
    authDomain: 'social-media-app-b5ea5.firebaseapp.com',
    storageBucket: 'social-media-app-b5ea5.firebasestorage.app',
    measurementId: 'G-GG5BNWNDWS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxKpDbQNRtDQOpuHjmQ7ZpNE65Y3dgjO0',
    appId: '1:208511786964:android:37fc32911c8b70d1a7c041',
    messagingSenderId: '208511786964',
    projectId: 'social-media-app-b5ea5',
    storageBucket: 'social-media-app-b5ea5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFkC65i0YaYyTJENe_iK1y122bxd92y5s',
    appId: '1:208511786964:ios:9fc11f47c48ae014a7c041',
    messagingSenderId: '208511786964',
    projectId: 'social-media-app-b5ea5',
    storageBucket: 'social-media-app-b5ea5.firebasestorage.app',
    iosBundleId: 'com.example.socialMediaApp',
  );

}