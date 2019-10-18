import 'package:firebase/firebase.dart';
import 'LDUser.dart';

class LDAuth {
  final Auth fbAuth;
  final GoogleAuthProvider _googleSignIn;

  LDAuth({Auth firebaseAuth, GoogleAuthProvider googleSignIn})
      : fbAuth = firebaseAuth ?? auth(),
        _googleSignIn = googleSignIn ?? GoogleAuthProvider();

  Future<UserCredential> signInWithGoogle() async {
    print("SIgn in with google called");
    var user = await fbAuth.signInWithPopup(_googleSignIn);
    print("user is: $user");
    return user;
  }

  Future<bool> isSignedIn() async {
    final currentUser = fbAuth.currentUser;
    return currentUser != null;
  }

  Stream<LDUser> get onAuthStateChange {
    return fbAuth.onAuthStateChanged.map(LDUser.fromFirebaseUser);
  }

  Future<dynamic> signOut() async {
    try {
      return Future.wait([
        fbAuth.signOut(),
      ]);
    } catch (e) {
      print('Error signin out: $e');
      throw '$e';
    }
  }

  Future<LDUser> getUser() async {
    return LDUser(
      displayName: fbAuth.currentUser.displayName,
      uid: fbAuth.currentUser.uid,
    );
  }
}
