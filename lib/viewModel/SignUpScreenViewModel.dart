import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/HomeScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUpScreenViewModel with ChangeNotifier {

  Authentication authentication;
  AuthenticationRepository repository = AuthenticationRepository();

  String displayName;
  String email;
  String password;

  SignUpScreenViewModel() {
    this.displayName = "";
    this.email = "";
    this.password = "";
  }

  void setDisplayName(String val) {
    displayName = val;
    notifyListeners();
  }

  void setEmail(String val) {
    email = val;
    notifyListeners();
  }

  void setPassword(String val) {
    password = val;
    notifyListeners();
  }

  bool isEmpty() {
    if (displayName.isEmpty || email.isEmpty || password.isEmpty) {
      return true;
    }
    return false;
  }

  void signIn(BuildContext context) {
    final ProgressDialog progress = new ProgressDialog(context);
    progress.show();
    repository.signUp(displayName, email, password)
        .then((value) {
          progress.hide();
          this.authentication = value;
          notifyListeners();
          if (this.authentication.authStatus == AuthStatus.signedIn) {
            moveHomeScreen(context);
          }
        });
  }

  void moveSignInScreen(BuildContext context) {
    Navigator.pop(context);
  }

  void moveHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen())
    );
  }

}