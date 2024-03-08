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
    apiKey: 'AIzaSyBDynzdx0OMPHYXSrVN7lMcx0C9GtZ0BYY',
    appId: '1:790943271641:web:81c29a3955e8cc6bcd8cc8',
    messagingSenderId: '790943271641',
    projectId: 'stepit-2de8f',
    authDomain: 'stepit-2de8f.firebaseapp.com',
    storageBucket: 'stepit-2de8f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZgNFdjHqAuuaiLJRVfgiQgVDcJKkdTn0',
    appId: '1:790943271641:android:1ea23c8084013c73cd8cc8',
    messagingSenderId: '790943271641',
    projectId: 'stepit-2de8f',
    storageBucket: 'stepit-2de8f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARl32688LixIl3KwIRx46w_gqw2dvlrV0',
    appId: '1:790943271641:ios:0734aaef7572cb1ecd8cc8',
    messagingSenderId: '790943271641',
    projectId: 'stepit-2de8f',
    storageBucket: 'stepit-2de8f.appspot.com',
    iosBundleId: 'com.project.stepit',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyARl32688LixIl3KwIRx46w_gqw2dvlrV0',
    appId: '1:790943271641:ios:a3b127036fa2b4bacd8cc8',
    messagingSenderId: '790943271641',
    projectId: 'stepit-2de8f',
    storageBucket: 'stepit-2de8f.appspot.com',
    iosBundleId: 'com.project.stepit.RunnerTests',
  );
}
