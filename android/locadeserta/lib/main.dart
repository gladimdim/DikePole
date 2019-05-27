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

  final ThemeData theme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.black,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      fontFamily: 'Montserrat',
      textTheme: TextTheme(title: TextStyle(color: Colors.white)));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      title: 'Loca Deserta',
      theme: theme,
      initialRoute: "/",
      routes: {
        "/": (context) => LoginView(
              auth: auth,
              onContinue: () => Navigator.pushNamed(context, "/main_menu"),
              onSetLocale: _onLocaleSet,
            ),
        "/main_menu": (context) => MainMenu(
              auth: auth,
            )
      },
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

  void _onLocaleSet(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }
}

class MyHome extends StatefulWidget {
  final Function onLocaleSet;

  @override
  _MyHomeState createState() => _MyHomeState();

  MyHome({@required this.onLocaleSet});
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loca Deserta'),
        actions: [
          FlatButton(
            child: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              auth.signOut();
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: LoginView(
          auth: auth,
          onContinue: () => Navigator.pushNamed(context, "/main_menu"),
          onSetLocale: widget.onLocaleSet),
    );
  }
}
