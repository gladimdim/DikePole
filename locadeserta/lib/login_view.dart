import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locadeserta/InheritedAuth.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/radiuses.dart';
import 'package:url_launcher/url_launcher.dart';

import 'locale_selection.dart';

class LoginView extends StatefulWidget {
  final VoidCallback onContinue;
  final Function onSetLocale;
  final Function(bool) onThemeChange;
  final bool darkTheme;

  LoginView(
      {this.onContinue,
      this.onSetLocale,
      this.onThemeChange,
      this.darkTheme = false});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      body: _buildBody(context),
      title: LDLocalizations.appTitle,
      actions: [
        AppBarObject(
          onTap: () => InheritedAuth.of(context).auth.signOut(),
          text: LDLocalizations.signOut,
        ),
        AppBarObject(
          onTap: () {
            widget.onThemeChange(!widget.darkTheme);
          },
          text: widget.darkTheme
              ? LDLocalizations.lightThemeLabel
              : LDLocalizations.darkThemeLabel,
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<User>(
      stream: InheritedAuth.of(context).auth.onAuthStateChange,
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
              locale: LDLocalizations.locale,
            ),
            Center(
              child: Text(LDLocalizations.versionLabel),
            ),
            Center(
              child: Material(
                color: Theme.of(context).backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: InkWell(
                    child: Text(
                      "For Privacy Policy Tap here.",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Theme.of(context).backgroundColor,
                        color: Theme.of(context).textTheme.title.color,
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
          child: BorderedContainer(
            child: SlideableButton(
              onPress: () => _onSignInPressed(context),
              child: Text(
                LDLocalizations.signInWithGoogle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 2,
          child: BorderedContainer(
            child: SlideableButton(
              onPress: () => _onSignInAnonPressed(context),
              child: Text(
                LDLocalizations.anonLogin,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginedView(User user, BuildContext context) {
    return SlideableButton(
      onPress: widget.onContinue,
      child: BorderedContainer(
        child: Container(
          height: 50.0,
          color: Theme.of(context).backgroundColor,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              LDLocalizations.start,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(User user, context) {
    var text = user == null
        ? LDLocalizations.welcomeText
        : LDLocalizations.greetUserByName(user.displayName);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(text),
      ),
    );
  }

  _onSignInPressed(context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await InheritedAuth.of(context).auth.signInWithCredentials(credential);
  }

  _onSignInAnonPressed(context) async {
    return await InheritedAuth.of(context).auth.signInAnonymously();
  }

  _setNewLocale(Locale locale) {
    widget.onSetLocale(locale);
  }

  @override
  void dispose() {
    super.dispose();
    print("disposing login view");
  }
}
