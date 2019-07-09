import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:locadeserta/catalog_view.dart';
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
      fontFamily: 'Roboto',
      textTheme: TextTheme(title: TextStyle(color: Colors.white)));

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black));
    return MaterialApp(
      locale: locale,
      title: 'Loca Deserta',
      theme: theme,
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => LoginView(
              auth: auth,
              onContinue: () => Navigator.pushNamed(context, "/main_menu"),
              onSetLocale: _onLocaleSet,
            ),
        "/main_menu": (context) => MainMenu(
              auth: auth,
            ),
        ExtractCatalogViewArguments.routeName: (context) =>
            ExtractCatalogViewArguments(),
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
