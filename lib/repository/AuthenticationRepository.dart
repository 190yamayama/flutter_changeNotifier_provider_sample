import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_app/api/firebase/AuthClient.dart';
import 'package:flutter_firebase_app/api/model/AuthStatus.dart';
import 'package:flutter_firebase_app/api/model/Authentication.dart';

class AuthenticationRepository {

  final BaseAuth _auth = new AuthClient();
  String _errorCode = "";
  String _errorMessage = "";

  Future<Authentication> checkAuthenticationStatus() async {
    try {
      User user = await _auth.currentUser();
      AuthStatus status = user != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      return new Authentication(status, user, _errorCode, _errorMessage, null);
    } on FirebaseAuthException catch(e) {
      _errorCode = e.code.toString();
      _errorMessage = "";
      return new Authentication(AuthStatus.failed, null, _errorCode, _errorMessage, e);
    } catch (e) {
      _errorMessage = "状態確認でエラーが発生しました。\n\n${e.toString()}";
      return new  Authentication(AuthStatus.failed, null, _errorCode, _errorMessage, e);
    } finally {

    }
  }

  Future<Authentication> signIn(String email, String password) async {
    _errorCode = "";
    _errorMessage = "";
    try {
      await _auth.signIn(email, password);
      User user = await _auth.currentUser();
      return new Authentication(AuthStatus.signedIn, user, "", "", null);
    } on FirebaseAuthException catch(e) {
      _errorCode = e.code.toString();
      _errorMessage = "";
      switch(_errorCode) {
        case "user-not-found":
          _errorMessage = "ユーザが存在しません\nサインアップしてください";
          break;
        case "wrong-password":
          _errorMessage = "パスワードが間違っています";
          break;
        default:
          _errorMessage = "サインインでエラーが発生しました。\n\n${e.toString()}";
      }
      return new Authentication(AuthStatus.failed, null, _errorCode, _errorMessage, e);
    } catch (e) {
      _errorMessage = "サインインでエラーが発生しました。\n\n${e.toString()}";
      return new Authentication(AuthStatus.failed, null, _errorCode, _errorMessage, e);
    } finally {

    }
  }

  Future<Authentication> signUp(String displayName, String email, String password) async {
    _errorCode = "";
    _errorMessage = "";
    try {
      await _auth.createUser(displayName, email, password);
      User user = await _auth.currentUser();
      return new Authentication(AuthStatus.signedIn, user, "", "", null);
    } on FirebaseAuthException catch(e) {
      _errorCode = e.code.toString();
      _errorMessage = "";
      switch(_errorCode) {
        case "email-already-in-use":
          _errorMessage = "既にユーザが存在します\nサインインしてください";
          break;
        default:
          _errorMessage = "サインアップでエラーが発生しました。\n\n${e.toString()}";
      }
      return new Authentication(AuthStatus.failed, null, _errorCode, _errorMessage, e);
    } catch (e) {
      _errorMessage = "サインアップでエラーが発生しました。\n\n${e.toString()}";
      return new Authentication(AuthStatus.failed, null, _errorCode, _errorMessage, e);
    } finally {

    }
  }

  Future<Authentication> signOut() async {
    _errorCode = "";
    _errorMessage = "";
    try {
      await _auth.signOut();
      return new Authentication(AuthStatus.notSignedIn, null, "", "", null);
    } on FirebaseAuthException catch(e) {
      _errorCode = e.code.toString();
      _errorMessage = '';
      return new Authentication(AuthStatus.failed, null, _errorCode, _errorMessage, e);
    } catch (e) {
      _errorMessage = 'サインアウトでエラーが発生しました。\n\n${e.toString()}';
      return new Authentication(AuthStatus.failed, null, _errorCode, _errorMessage, e);
    } finally {

    }
  }

}
