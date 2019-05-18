import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locadeserta/animations/TweenImage.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';

var version = "1.47";

class LoginView extends StatefulWidget {
  final Auth auth;
  final VoidCallback onContinue;
  final Function onSetLocale;

  LoginView({this.auth, this.onContinue, this.onSetLocale});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _selectedLocale = 'en';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: widget.auth.onAuthStateChange,
      initialData: null,
      builder: (context, snapshot) {
        User user = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Center(
                child: TweenImage(
                  last: AssetImage("images/background/cossack_0.jpg"),
                  first: AssetImage("images/background/c_cossack_0.jpg"),
                ),
              ),
            ),
            _buildTextDisplayName(user, context),
            if (snapshot.data == null)
              RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.title.color,
                  onPressed: _onSignInPressed,
                  child: Text(
                    LDLocalizations.of(context).signInWithGoogle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title,
                  )),
            if (snapshot.data != null) _buildLoginedView(user, context),
            _buildLocaleSelection(),
            Center(
              child: Text("Version: $version"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginedView(User user, BuildContext context) {
    return RaisedButton(
      onPressed: widget.onContinue,
      color: Theme.of(context).primaryColor,
      child: Text(LDLocalizations.of(context).start,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title),
    );
  }

  Widget _buildTextDisplayName(User user, context) {
    var userName = user == null
        ? LDLocalizations.of(context).unregisteredUsername()
        : user.displayName;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(LDLocalizations.of(context).greetUserByName(userName)),
      ),
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

    await widget.auth.signInWithCredentials(credential);
  }

  Widget _buildLocaleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: 'uk',
          groupValue: _selectedLocale,
          onChanged: _setNewLocale,
        ),
        Text('🇺🇦'),
        Radio(
          value: 'pl',
          groupValue: _selectedLocale,
          onChanged: _setNewLocale,
        ),
        Text('🇵🇱'),
        Radio(
          value: 'en',
          groupValue: _selectedLocale,
          onChanged: _setNewLocale,
        ),
        Text('🇺🇸'),
      ],
    );
  }

  _setNewLocale(String newLocale) {
    var locale = Locale(newLocale);
    setState(() {
      _selectedLocale = newLocale;
    });
    widget.onSetLocale(locale);
  }
}
