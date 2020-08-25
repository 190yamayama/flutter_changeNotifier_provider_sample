import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/SplashScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomeScreenViewModel with ChangeNotifier {

  Authentication authentication;
  AuthenticationRepository repository = AuthenticationRepository();

  String displayText() {
    String displayName = authentication?.firebaseUser?.displayName ?? "";
    return "$displayName さん　ホームですよ〜";
  }

  void readAuthStatus() {
    repository.checkAuthenticationStatus()
        .then((value) {
          this.authentication = value;
          notifyListeners();
        });
  }

  void signOut(BuildContext context) {
    final ProgressDialog progress = new ProgressDialog(context);
    progress.show();
    repository.signOut()
        .then((value) {
          progress.hide();
          this.authentication = value;
          if (this.authentication.authStatus == AuthStatus.notSignedIn) {
            moveSplashScreen(context);
          }
        });
  }

  void moveSplashScreen(BuildContext context) {
    // 先に戻っておかないとなぜかpushReplacementがpushの動きをする
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => SplashScreen())
    );
  }
}