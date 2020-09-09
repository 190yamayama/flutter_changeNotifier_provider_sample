import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/api/model/AuthStatus.dart';
import 'package:flutter_firebase_app/api/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/HomeScreen.dart';
import 'package:flutter_firebase_app/widget/screen/SignInScreen.dart';
import 'package:flutter_firebase_app/widget/screen/SignUpScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignInScreenViewModel extends ChangeNotifier {

  Authentication _authentication;
  AuthenticationRepository _repository;

  String _email = "";
  String _password = "";

  SignInScreenViewModel([AuthenticationRepository repository]) {
    _repository = repository ?? AuthenticationRepository();
    _email = "";
    _password = "";
  }

  void setEmail(String val) {
    _email = val;
  }

  void setPassword(String val) {
    _password = val;
  }

  String errorMessage() {
    return _authentication?.errorMessage ?? "";
  }

  bool isEmpty() {
    if (_email.isEmpty || _password.isEmpty) {
      return true;
    }
    return false;
  }

  bool validateAndSave() {
    final form = SignInScreen.formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void signIn(BuildContext context) {
    final progress = new ProgressDialog(context);
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