import 'package:flutter/material.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/locale_selection.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/radiuses.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatefulWidget {
  static const String routeName = "/login_view";
  final VoidCallback onContinue;
  final Function onSetLocale;
  final Function(bool) onThemeChange;
  final bool darkTheme;

  LoginView(
      {
        required this.onContinue,
      required this.onSetLocale,
      required this.onThemeChange,
      this.darkTheme = false});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      body: _buildBody(context),
      title: LDLocalizations.appTitle,
      showBackButton: false,
      actions: [
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Material(
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: InkWell(
                child: Text(
                  "Loca Deserta Site",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Theme.of(context).backgroundColor,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
                onTap: () async {
                  if (await canLaunch("https://locadeserta.com/")) {
                    await launch("https://locadeserta.com/");
                  }
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: getAllRoundedBorderRadius(),
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
        ),
        SizedBox(
          height: 20,
        ),
        _buildLoginedView(context),
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
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
                onTap: () async {
                  if (await canLaunch(
                      "https://locadeserta.com/privacy_policy.html")) {
                    await launch("https://locadeserta.com/privacy_policy.html");
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginedView(BuildContext context) {
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

  _setNewLocale(Locale locale) {
    widget.onSetLocale(locale);
  }

  @override
  void dispose() {
    super.dispose();
    print("disposing login view");
  }
}
