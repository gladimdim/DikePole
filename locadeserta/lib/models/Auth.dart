import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  final String displayName;

  static User fromFirebaseUser(FirebaseUser user) {
    return User(
        uid: user.uid,
        displayName: user.displayName != null ? user.displayName : "Cossack");
  }

  User({this.uid, this.displayName});
}

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<User> currentUser() async {
    var fbUser = await _auth.currentUser();
    user = User.fromFirebaseUser(fbUser);
    return User.fromFirebaseUser(fbUser);
  }

  Stream<User> get onAuthStateChange {
    return _auth.onAuthStateChanged.map(User.fromFirebaseUser);
  }

  Future<User> signInWithCredentials(AuthCredential creds) async {
    final FirebaseUser user = await _auth.signInWithCredential(creds);
    return User.fromFirebaseUser(user);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> signInAnonymously() async {
    await _auth.signInAnonymously();
  }
}
