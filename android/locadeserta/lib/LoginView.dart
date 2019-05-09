import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locadeserta/animations/TweenImage.dart';
import 'package:locadeserta/models/Auth.dart';

class LoginView extends StatelessWidget {
  final Auth auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  LoginView({this.auth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onAuthStateChange,
      initialData: null,
      builder: (context, snapshot) {
        User user = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: TweenImage(
                  last: AssetImage("images/background/cossack_0.jpg"),
                  first: AssetImage("images/background/c_cossack_0.jpg"),
                  height: 500.0,
                ),
              ),
              snapshot.data == null ? Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
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
              ) : _buildLoginedView(user),
            ],
          );
      },
    );
  }

  Widget _buildLoginedView(User user) {
    return Column(
      children: [
        _buildTextDisplayName(user.displayName),
        RaisedButton(
          color: Colors.green,
          onPressed: _onContinuePressed,
            child: Text(
              "Почати",
              textAlign: TextAlign.center,
            ),
        )
      ]
    );
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

    await auth.signInWithCredentials(credential);
  }

  void _onContinuePressed() {
    print("go on");
  }
}
