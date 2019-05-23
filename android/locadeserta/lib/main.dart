import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:locadeserta/main_menu.dart';
import 'package:locadeserta/login_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';

void main() => runApp(LocaDesertaApp());

final Auth auth = Auth();

class LocaDesertaApp extends StatefulWidget {
  @override
  _LocaDesertaAppState createState() => _LocaDesertaAppState();
}

class _LocaDesertaAppState extends State<LocaDesertaApp> {
  Locale locale = Locale('en');

  bool userPressedContinue = false;
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
                  userPressedContinue = false;
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
    return userPressedContinue
          ? MainMenu(auth: auth)
          : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: LoginView(
              auth: auth,
              onContinue: onContinue,
              onSetLocale: (Locale newLocale) => setState(() {
                locale = newLocale;
              }),
            ),
          );
  }

  void onContinue() {
    setState(() {
      userPressedContinue = true;
    });
  }
}
