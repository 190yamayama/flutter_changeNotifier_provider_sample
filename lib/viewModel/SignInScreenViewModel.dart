import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/HomeScreen.dart';
import 'package:flutter_firebase_app/widget/screen/SignUpScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignInScreenViewModel with ChangeNotifier {

  Authentication _authentication;
  final _repository = AuthenticationRepository();

  String _email = "";
  String _password = "";

  SignInScreenViewModel() {
    _email = "";
    _password = "";
  }

  bool isEmpty() {
    if (_email.isEmpty || _password.isEmpty) {
      return true;
    }
    return false;
  }

  void setEmail(String val) {
    _email = val;
    notifyListeners();
  }

  void setPassword(String val) {
    _password = val;
    notifyListeners();
  }

  String errorMessage() {
    return _authentication?.errorMessage ?? "";
  }

  void signIn(BuildContext context) {
    final ProgressDialog progress = new ProgressDialog(context);
    progress.show();
    _repository.signIn(_email, _password)
        .then((value) {
          progress.hide();
          _authentication = value;
          notifyListeners();
          if (_authentication.authStatus == AuthStatus.signedIn) {
            _moveHomeScreen(context);
          }
        });
  }

  void moveSignUpScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => SignUpScreen())
    );
  }

  void _moveHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen())
    );
  }

}