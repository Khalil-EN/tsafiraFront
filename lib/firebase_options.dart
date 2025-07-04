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
    apiKey: 'AIzaSyAOf9dIh-P-unRfmYYSpnVRnDOR1kIdUtA',
    appId: '1:1081539218547:web:aeadad7f278f062961ee06',
    messagingSenderId: '1081539218547',
    projectId: 'tsafira-firebase',
    authDomain: 'tsafira-firebase.firebaseapp.com',
    storageBucket: 'tsafira-firebase.firebasestorage.app',
    measurementId: 'G-33HGECZLQR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAHYrLhpq794frUHzjZ7MS_et9CmltSVUs',
    appId: '1:1081539218547:android:e70f4c00ba8138e961ee06',
    messagingSenderId: '1081539218547',
    projectId: 'tsafira-firebase',
    storageBucket: 'tsafira-firebase.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBumAL_O8GjmIwPH08TVJzf5EvOaKajfVw',
    appId: '1:1081539218547:ios:a30c4c86fdbd9ddf61ee06',
    messagingSenderId: '1081539218547',
    projectId: 'tsafira-firebase',
    storageBucket: 'tsafira-firebase.firebasestorage.app',
    iosClientId: '1081539218547-tasdvdt68hhp2ovqcjemk23argdq7hnm.apps.googleusercontent.com',
    iosBundleId: 'com.example.tsafira',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBumAL_O8GjmIwPH08TVJzf5EvOaKajfVw',
    appId: '1:1081539218547:ios:a30c4c86fdbd9ddf61ee06',
    messagingSenderId: '1081539218547',
    projectId: 'tsafira-firebase',
    storageBucket: 'tsafira-firebase.firebasestorage.app',
    iosBundleId: 'com.example.tsafira',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAOf9dIh-P-unRfmYYSpnVRnDOR1kIdUtA',
    appId: '1:1081539218547:web:c96edccfebfea07361ee06',
    messagingSenderId: '1081539218547',
    projectId: 'tsafira-firebase',
    authDomain: 'tsafira-firebase.firebaseapp.com',
    storageBucket: 'tsafira-firebase.firebasestorage.app',
    measurementId: 'G-HV0MRXMRKP',
  );

}