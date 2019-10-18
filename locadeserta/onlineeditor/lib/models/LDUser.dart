import 'package:firebase/firebase.dart';

class LDUser {
  final String uid;
  final String displayName;

  static LDUser fromFirebaseUser(User user) {
    return LDUser(
        uid: user.uid,
        displayName: user.displayName != null ? user.displayName : "Cossack");
  }

  LDUser({this.uid, this.displayName});
}
