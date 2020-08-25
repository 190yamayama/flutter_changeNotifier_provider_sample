import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/HomeScreen.dart';
import 'package:flutter_firebase_app/widget/screen/SignUpScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignInScreenViewModel with ChangeNotifier {

  Authentication authentication;
  AuthenticationRepository repository = AuthenticationRepository();

  String email = "";
  String password = "";

  SignInScreenViewModel() {
    this.email = "";
    this.password = "";
  }

  bool isEmpty() {
    if (email.isEmpty || password.isEmpty) {
      return true;
    }
    return false;
  }

  void setEmail(String val) {
    email = val;
    notifyListeners();
  }

  void setPassword(String val) {
    password = val;
    notifyListeners();
  }

  void signIn(BuildContext context) {
    final ProgressDialog progress = new ProgressDialog(context);
    progress.show();
    repository.signIn(email, password)
        .then((value) {
          progress.hide();
          this.authentication = value;
          notifyListeners();
          if (this.authentication.authStatus == AuthStatus.signedIn) {
            moveHomeScreen(context);
          }
        });
  }

  void moveSignUpScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => SignUpScreen())
    );
  }

  void moveHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen())
    );
  }

}