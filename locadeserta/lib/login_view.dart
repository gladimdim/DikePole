import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/radiuses.dart';
import 'package:url_launcher/url_launcher.dart';

import 'locale_selection.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loca Deserta'),
        actions: [
          FlatButton(
            textColor: Theme.of(context).textTheme.title.color,
            child: Text(
              LDLocalizations.of(context).signOut,
            ),
            onPressed: () {
              widget.auth.signOut();
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
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
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ClipRRect(
                    borderRadius: getAllRoundedBorderRadius(),
                    child: Hero(
                      tag: "CossackHero",
                      child: TweenImage(
                        repeat: true,
                        last: AssetImage("images/background/cossack_0.jpg"),
                        first: AssetImage("images/background/c_cossack_0.jpg"),
                        duration: 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildWelcomeText(user, context),
            SizedBox(
              height: 20,
            ),
            if (snapshot.data == null) _buildLoginButtons(context),
            if (snapshot.data != null) _buildLoginedView(user, context),
            LocaleSelection(
              onLocaleChanged: _setNewLocale,
              locale: Localizations.localeOf(context),
            ),
            Center(
              child: Text(LDLocalizations.of(context).versionLabel),
            ),
            Center(
              child: Material(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "For Privacy Policy Tap here.",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch(
                        "https://locadeserta.com/privacy_policy.html")) {
                      await launch(
                          "https://locadeserta.com/privacy_policy.html");
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.title.color,
            onPressed: _onSignInPressed,
            child: Text(
              LDLocalizations.of(context).signInWithGoogle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: RaisedButton(
            onPressed: _onSignInAnonPressed,
            color: Theme.of(context).primaryColor,
            child: Text(LDLocalizations.of(context).anonLogin,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginedView(User user, BuildContext context) {
    return SlideableButton(
      onPress: widget.onContinue,
      child: Container(
        height: 50.0,
        color: Theme.of(context).primaryColor,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            LDLocalizations.of(context).start,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(User user, context) {
    var text = user == null
        ? LDLocalizations.of(context).welcomeText
        : LDLocalizations.of(context).greetUserByName(user.displayName);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(text),
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

  _onSignInAnonPressed() async {
    return await widget.auth.signInAnonymously();
  }

  _setNewLocale(Locale locale) {
    widget.onSetLocale(locale);
  }
}