import 'package:flutter/material.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/web/main_menu.dart';
import 'package:locadeserta/web/models/LDAuth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/web/locale_selection_view.dart';
import 'package:locadeserta/web/views/inherited_auth.dart';
import 'package:locadeserta/web/models/LDUser.dart';

class LoginView extends StatefulWidget {
  static const String routeName = "/login_view";
  final VoidCallback onContinue;
  final Function onSetLocale;
  final LDAuth auth = LDAuth();

  LoginView({this.onContinue, this.onSetLocale});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<LDUser>(
      stream: InheritedAuth.of(context).auth.onAuthStateChange,
      initialData: null,
      builder: (context, snapshot) {
        LDUser user = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Hero(
                    tag: "CossackHero",
                    child: TweenImage(
                      repeat: false,
                      last: AssetImage("images/background/cossack_0.jpg"),
                      first: AssetImage("images/background/c_cossack_0.jpg"),
                      duration: 4,
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
            ),
            Center(
              child: Text(LDLocalizations.versionLabel),
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
            onPressed: () => _onSignInPressed(context),
            child: Text(
              LDLocalizations.signInWithGoogle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 2,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.title.color,
            onPressed: () => _onAnonSignInPressed(context),
            child: Text(
              LDLocalizations.anonLogin,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginedView(LDUser user, BuildContext context) {
    return SlideableButton(
      onPress: () {
        Navigator.pushNamed(context, MainMenu.routeName);
      },
      child: Container(
        height: 50.0,
        color: Theme.of(context).primaryColor,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            LDLocalizations.start,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(LDUser user, context) {
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
    await InheritedAuth.of(context).auth.signInWithGoogle();
  }

  _onAnonSignInPressed(context) async {
    await InheritedAuth.of(context).auth.signInAnonymously();
  }

  _setNewLocale(Locale locale) {
    LDLocalizations.locale = locale;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    print("disposing login view");
  }
}
