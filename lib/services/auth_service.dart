import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth? _auth;
  User? _user;

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthService() {
    try {
      _auth = FirebaseAuth.instance;
      _auth!.authStateChanges().listen((User? user) {
        _user = user;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Firebase Auth unavailable, running without it: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth?.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      await _auth?.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth?.signOut();
  }
}
