import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locadeserta/animations/TweenImage.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';

class LoginView extends StatelessWidget {
  final Auth auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  VoidCallback onContinue;
  LoginView({this.auth, this.onContinue});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onAuthStateChange,
      initialData: null,
      builder: (context, snapshot) {
        User user = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: TweenImage(
                last: AssetImage("images/background/cossack_0.jpg"),
                first: AssetImage("images/background/c_cossack_0.jpg"),
                height: 500.0,
              ),
            ),
            snapshot.data == null
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 12.0, right: 12.0),
                    child: RaisedButton(
                        color: Colors.blue[300],
                        onPressed: _onSignInPressed,
                        child: Text(
                          LDLocalizations.of(context).signInWithGoogle,
                          textAlign: TextAlign.center,
                        )),
                  )
                : _buildLoginedView(user, context),
          ],
        );
      },
    );
  }

  Widget _buildLoginedView(User user, BuildContext context) {
    return Column(children: [
      _buildTextDisplayName(user.displayName, context),
      RaisedButton(
        color: Colors.green,
        onPressed: onContinue,
        child: Text(
          LDLocalizations.of(context).start,
          textAlign: TextAlign.center,
        ),
      )
    ]);
  }

  Padding _buildTextDisplayName(String displayName, context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(LDLocalizations.of(context).greetUserByName(displayName)),
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
}
