import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/viewModel/SplashScreenViewModel.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenViewModel viewModel = SplashScreenViewModel();

  @override
  Widget build(BuildContext context) {

//    final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
//    // Push通知の許可
//    _firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(sound: true, badge: true, alert: true));
//    // Push通知の許可・設定(iOS)
//    _firebaseMessaging.onIosSettingsRegistered
//        .listen((IosNotificationSettings settings) {
//      print("Settings registered: $settings");
//    });

    // 認証確認
    viewModel.moveNextScreen(context);

    return Scaffold(
      body: Center(child: Image(image: AssetImage('assets/splash.png'))),
    );
  }
}
