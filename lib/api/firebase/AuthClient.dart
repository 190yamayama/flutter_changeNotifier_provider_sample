import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_app/api/model/StoreNode.dart';
import 'package:flutter_firebase_app/util/Util.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<void> signOut();
  Future<String> createUser(String displayName, String email, String password);
  Future<String> updateUser(String displayName, String email, String password);
  Future<User> currentUser();
}

class AuthClient implements BaseAuth {

  final FirebaseAuth _firebaseAuth;
  final FirebaseMessaging _firebaseMessaging;
  final BaseUtil _util;
  final FirebaseFirestore _db;

  AuthClient({FirebaseAuth firebaseAuth, FirebaseMessaging firebaseMessaging, FirebaseFirestore db, BaseUtil util})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseMessaging = firebaseMessaging ?? new FirebaseMessaging(),
        _db = db ?? FirebaseFirestore.instance,
        _util = util ?? new Util()
  ;

  Future<String> signIn(String email, String password) async {

    UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    // deviceToken取得
    String token = await _firebaseMessaging.getToken();

    // Usersテーブル更新
    await _db.collection(StoreNode.users.node).doc(authResult.user.uid).set({
      "deviceToken": token,
      "signInAt": _util.getNowDateAndTime()
    });

    return authResult.user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String> createUser(String displayName, String email, String password) async {

    UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    // deviceToken取得
    String _token = await _firebaseMessaging.getToken();

    // Usersテーブル作成
    await _db.collection(StoreNode.users.node).doc(authResult.user.uid).set({
      "deviceToken": _token,
      "displayName": displayName,
      "createdAt": _util.getNowDateAndTime(),
      "updatedAt": _util.getNowDateAndTime(),
      "deletedAt": ''
    });

    return authResult.user.uid;
  }

  Future<String> updateUser(String displayName, String email, String password) async {

    UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    // deviceToken取得
    String _token = await _firebaseMessaging.getToken();

    // Usersテーブル作成
    await _db.collection(StoreNode.users.node).doc(authResult.user.uid).set({
      "deviceToken": _token,
      "displayName": displayName,
      "updatedAt": _util.getNowDateAndTime()
    });

    return authResult.user.uid;
  }

  Future<User> currentUser() async {
    return _firebaseAuth.currentUser;
  }

}