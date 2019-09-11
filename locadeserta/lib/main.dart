import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:locadeserta/creator/components/create_view.dart';
import 'package:locadeserta/creator/components/edit_passage_view.dart';
import 'package:locadeserta/creator/components/edit_story.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/export_pdf_view.dart';
import 'package:locadeserta/main_menu.dart';
import 'package:locadeserta/login_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() async {
  try {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    await FlutterStatusbarcolor.setNavigationBarColor(Colors.black);
    await FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
  } catch (e) {
    print(e);
  }
  runApp(LocaDesertaApp());
}

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
        ExtractExportPdfViewArguments.routeName: (context) =>
            ExtractExportPdfViewArguments(),
        "/create": (context) => CreateView(
              locale: locale,
              auth: auth,
            ),
        ExtractEditStoryViewArguments.routeName: (context) =>
            ExtractEditStoryViewArguments(auth: auth),
        ExtractArgumentsGameView.routeName: (context) =>
            ExtractArgumentsGameView(),
        ExtractEditPassageView.routeName: (context) => ExtractEditPassageView()
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
