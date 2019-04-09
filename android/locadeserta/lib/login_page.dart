import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  final Function onUserLoggedIn;

  LoginView({this.onUserLoggedIn});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser authedUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>>_getSavedUserUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = await prefs.get('uid');
    String displayName = await prefs.get('displayName');
    widget.onUserLoggedIn(null, uid);
    return {
      "uid": uid,
      "displayName": displayName
    };
  }
  @override
  Widget build(BuildContext context) {
    if (authedUser == null) {
      return FutureBuilder(
        future: _getSavedUserUID(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data["displayName"] != null) {
            return _buildTextDisplayName(snapshot.data['displayName']);
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
              child: SizedBox(
                height: 50.0,
                child: RaisedButton(
                    color: Colors.blue[300],
                    onPressed: _onSignInPressed,
                    child: Text(
                      "Зайти з Google ID",
                      textAlign: TextAlign.center,
                    )),
              ),
            );
          }
        },

      );
    } else {
      return _buildTextDisplayName(authedUser.displayName);
    }
  }

  Padding _buildTextDisplayName(String displayName) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Center(child: Text("Добрий день, $displayName")),
    );
  }

  _onSignInPressed() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    setState(() {
      authedUser = user;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("uid", user.uid);
    await prefs.setString("displayName", user.displayName);
    widget.onUserLoggedIn(user);
  }
}
