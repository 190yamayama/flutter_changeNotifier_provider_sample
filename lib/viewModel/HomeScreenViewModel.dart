import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/SplashScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomeScreenViewModel with ChangeNotifier {

  Authentication _authentication;
  final _repository = AuthenticationRepository();

  String displayText() {
    String displayName = _authentication?.firebaseUser?.displayName ?? "";
    return "$displayName さん　ホームですよ〜";
  }

  void readAuthStatus() {
    _repository.checkAuthenticationStatus()
        .then((value) {
          _authentication = value;
          notifyListeners();
        });
  }

  void signOut(BuildContext context) {
    final progress = new ProgressDialog(context);
    progress.show();
    _repository.signOut()
        .then((value) {
          progress.hide();
          _authentication = value;
          if (_authentication.authStatus == AuthStatus.notSignedIn) {
            _moveSplashScreen(context);
          }
        });
  }

  void _moveSplashScreen(BuildContext context) {
    // 先に戻っておかないとなぜかpushReplacementがpushの動きをする
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => SplashScreen())
    );
  }
}