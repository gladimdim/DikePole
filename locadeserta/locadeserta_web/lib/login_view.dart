import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/models/Localizations.dart';
import 'animations/fade_images.dart';
import 'animations/slideable_button.dart';
import 'package:locadeserta_web/locale_selection.dart';
import 'models/Auth.dart';
import 'package:locadeserta_web/radiuses.dart';

class LoginView extends StatefulWidget {
  final Auth auth;
  final VoidCallback onContinue;
  final Function onSetLocale;
  final Locale locale;
  LDLocalizations localization;

  LoginView({this.auth, this.onContinue, this.onSetLocale, this.locale}) {
    localization = LDLocalizations(locale);
  }

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loca Deserta'),
        actions: [
          FlatButton(
            textColor: Theme.of(context).textTheme.title.color,
            child: Text(
              widget.localization.signOut,
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
              locale: widget.locale,
            ),
            Center(
              child: Text("1.68"),
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
            onPressed: () => {},
            child: Text(
              widget.localization.signInWithGoogle,
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
            child: Text(widget.localization.anonLogin,
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
            widget.localization.start,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(User user, context) {
    var text = user == null
        ? widget.localization.welcomeText
        : user.displayName;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(text),
      ),
    );
  }

  _onSignInAnonPressed() async {
    return await widget.auth.signInAnonymously();
  }

  _setNewLocale(Locale locale) {
    widget.onSetLocale(locale);
  }
}
