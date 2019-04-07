import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  @override
  Widget build(BuildContext context) {
    if (authedUser == null) {
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
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(child: Text("Добрий день, ${authedUser.displayName}")),
      );
    }
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
    widget.onUserLoggedIn(user);
  }
}
