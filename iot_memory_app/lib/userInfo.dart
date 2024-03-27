import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

String url = "https://simon-game-4d363-default-rtdb.firebaseio.com/";
enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthRepository with ChangeNotifier {
  String _userName = "";
  Map memory_data = {};
  Map speed_data = {};
  Status _status = Status.Uninitialized;
  DatabaseReference _db;
  final FirebaseAuth _auth;
  User? _user;

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
      throw 'Error signing up: $e'; // Throw the error message
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
      await getData();
      await setCurrentUser();
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      throw 'Error signing in: $e'; // Throw the error message
    }
  }

  Future<Map<dynamic, dynamic>?> getData() async {
  try {
    Map<dynamic, dynamic>? user_data = (await _db.child(_userName)
        .once()
        .then((result) => result.snapshot.value)) as Map<dynamic, dynamic>?;
    if(user_data == null) user_data = {};
    int score = 0;
    for (var i = 1; i <= 16; i++) {
      String level = 'level_$i';
      score = user_data['memory_game']?[level] ?? 0;
      memory_data[level] = score;
      score = user_data['speed_game']?[level] ?? 0;
      speed_data[level] = score;
    }
    user_data?['memory_game'] = memory_data;
    user_data?['speed_game'] = speed_data;
    print(user_data);
    return user_data;
  } catch (e) {
    // Handle any errors here
    print('Error fetching data: $e');
    // Return an empty map on error
    return {};
  }
}

  Future<bool> setCurrentUser() async {
    try {
      DatabaseReference reference = FirebaseDatabase.instance.reference().child('currentUser');
      reference.set(_userName).then((_) {
        print('Data set successfully');
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}



