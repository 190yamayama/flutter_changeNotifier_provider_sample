import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/api/model/AuthStatus.dart';
import 'package:flutter_firebase_app/api/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/HomeScreen.dart';
import 'package:flutter_firebase_app/widget/screen/SignInScreen.dart';
import 'package:flutter_firebase_app/widget/screen/SignUpScreen.dart';

class SplashScreenViewModel {

  Authentication _authentication;
  AuthenticationRepository _repository = AuthenticationRepository();

  SplashScreenViewModel([AuthenticationRepository repository]) {
    _repository = repository ?? AuthenticationRepository();
  }

  void moveNextScreen(BuildContext context) {
    _repository.checkAuthenticationStatus()
        .then((value) {
          _authentication = value;
          Timer(Duration(seconds: 2), () {
            // （backで戻れないように）置き換えて遷移する
            switch (_authentication.authStatus) {
              case AuthStatus.notSignedIn:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => SignInScreen())
                );
                break;
              case AuthStatus.signedUp:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => SignUpScreen())
                );
                break;
              case AuthStatus.signedIn:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => HomeScreen())
                );
                break;
              case AuthStatus.failed:
                // TODO: ここでエラーになった時の処理を決めて書く。ポップアップメッセージ出してリトライするか？
                break;
              case AuthStatus.initState:
                break;
            }
          });
    });
  }

}
