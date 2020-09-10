import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/api/firebase/model/AuthStatus.dart';
import 'package:flutter_firebase_app/api/firebase/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/HomeScreen.dart';
import 'package:flutter_firebase_app/widget/screen/SignUpScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUpScreenViewModel with ChangeNotifier {

  Authentication _authentication;
  AuthenticationRepository _repository;

  String _displayName;
  String _email;
  String _password;

  SignUpScreenViewModel([AuthenticationRepository repository]) {
    _repository = repository ?? AuthenticationRepository();
    _displayName = "";
    _email = "";
    _password = "";
  }

  void setDisplayName(String val) {
    _displayName = val;
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
    if (_displayName.isEmpty || _email.isEmpty || _password.isEmpty) {
      return true;
    }
    return false;
  }

  bool validateAndSave() {
    final form = SignUpScreen.formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void signIn(BuildContext context) {
    final progress = new ProgressDialog(context);
    progress.show();
    _repository.signUp(_displayName, _email, _password)
        .then((value) {
          progress.hide();
          _authentication = value;
          notifyListeners();
          if (_authentication.authStatus == AuthStatus.signedIn) {
            _moveHomeScreen(context);
          }
        });
  }

  void moveSignInScreen(BuildContext context) {
    Navigator.pop(context);
  }

  void _moveHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen())
    );
  }

}