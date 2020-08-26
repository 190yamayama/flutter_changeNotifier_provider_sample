import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/HomeScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUpScreenViewModel with ChangeNotifier {

  Authentication _authentication;
  final _repository = AuthenticationRepository();

  String _displayName;
  String _email;
  String _password;

  SignUpScreenViewModel() {
    _displayName = "";
    _email = "";
    _password = "";
  }

  void setDisplayName(String val) {
    _displayName = val;
    notifyListeners();
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

  bool isEmpty() {
    if (_displayName.isEmpty || _email.isEmpty || _password.isEmpty) {
      return true;
    }
    return false;
  }

  void signIn(BuildContext context) {
    final ProgressDialog progress = new ProgressDialog(context);
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