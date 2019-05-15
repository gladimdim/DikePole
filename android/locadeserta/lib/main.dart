import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:locadeserta/LandingView.dart';
import 'package:locadeserta/LoginView.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';

void main() => runApp(LocaDesertaApp());

final Auth auth = Auth();

class LocaDesertaApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _LocaDesertaAppState createState() => _LocaDesertaAppState();
}

class _LocaDesertaAppState extends State<LocaDesertaApp> {
  Locale locale = Locale('en');
  String _selectedLocale = 'en';
  bool userLoggedIn = false;
  final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    backgroundColor: Colors.white,
    accentColor: Colors.black,
    fontFamily: 'Montserrat',
    textTheme: TextTheme(
      title: TextStyle(
        color: Colors.white
      )
    )
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      title: 'Loca Deserta',
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Loca Deserta'),
          actions: [
            FlatButton(
              child: Icon(
                Icons.exit_to_app,
                color: theme.backgroundColor,
              ),
              onPressed: () {
                setState(() {
                  userLoggedIn = false;
                });
                auth.signOut();
              },
            ),
          ],
        ),
        backgroundColor: theme.backgroundColor,
        body: _buildBody(),
      ),
      localizationsDelegates: [
        const LDLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('uk'),
        Locale('pl'),
      ],
    );
  }

  Widget _buildBody() {
    return userLoggedIn
          ? LandingView(auth: auth)
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: LoginView(
                    auth: auth,
                    onContinue: onContinue,
                  ),
                ),
                Container(
                  child: _buildLocaleSelection(),
                )
              ],
            );
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
    setState(() {
      _selectedLocale = newLocale;
      locale = Locale(newLocale);
    });
  }

  void onContinue() {
    setState(() {
      userLoggedIn = true;
    });
  }
}
