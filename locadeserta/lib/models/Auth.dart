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
    return _auth.onAuthStateChanged.map((fbUser) {
      user = User.fromFirebaseUser(fbUser);
      return user;
    });
  }

  Future<User> signInWithCredentials(AuthCredential creds) async {
    final AuthResult fbUser = await _auth.signInWithCredential(creds);
    user = User.fromFirebaseUser(fbUser.user);
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> signInAnonymously() async {
    var fbUser = await _auth.signInAnonymously();
    user = User.fromFirebaseUser(fbUser.user);
    return user;
  }
}
