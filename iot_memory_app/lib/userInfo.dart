import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
String url = "https://simon-game-4d363-default-rtdb.firebaseio.com/";
enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthRepository with ChangeNotifier {
  String _userName = "";
  Status _status = Status.Uninitialized;
  DatabaseReference _db;
  final FirebaseAuth _auth;
  User? _user;

  Status get status => _status;
  User? get user => _user;
  String get userName => _userName;

  AuthRepository.instance(FirebaseApp iot_app) : _auth = FirebaseAuth.instance,
    _db = FirebaseDatabase(app: iot_app,databaseURL: url).reference()
  {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _user = _auth.currentUser;
    _onAuthStateChanged(_user);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<UserCredential?> signUp(String username, String password) async {
    try {
      _status = Status.Authenticating;
      final email ='$username@example.com';
      notifyListeners();
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      _userName = username;
      notifyListeners();
      return userCredential;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      throw 'Error signing up: $e';
    }
  }

  Future<bool> signIn(String username, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      String email = '$username@example.com';
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      _userName = username;
      await setCurrentUser();
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      throw 'Error signing in: $e';
    }
  }

  Future setCurrentUser({String name = ""}) async {
    if (name == "") name = _userName;
    try {
      DatabaseReference reference = FirebaseDatabase.instance.reference().child('currentUser');
      await reference.set(name).then((_) {
      });
    } catch (e) {
      print(e);
      throw 'Error setCurrentUser: $e';
    }
  }

  Future logOut() async {
    try {
      await setCurrentUser(name:"None");
      await _auth.signOut();
      _status = Status.Unauthenticated;
      notifyListeners();
    } catch (e) {
      print(e);
      throw 'Error signing out: $e';
    }
  }

  Stream<DatabaseEvent> getDataStream(){
    return _db.child('$_userName').onValue;
  }
}



