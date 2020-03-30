import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Registering,
  Registered
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;

  FirebaseUser get user => _user;

  String successMesssage = "Successfully created account. Please sign in!";

  Future<String> signUp(String email, String password) async {
    String result = "";
    try {
      _status = Status.Registering;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password:
      password);
      _status = Status.Registered;
      notifyListeners();
      result = successMesssage;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      result = e.code.toString();
    }

    return result;
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}