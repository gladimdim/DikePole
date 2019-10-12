import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:locadeserta/InheritedAuth.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:locadeserta/creator/components/create_view.dart';
import 'package:locadeserta/creator/components/edit_node_view.dart';
import 'package:locadeserta/creator/components/edit_story.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/export_pdf_view.dart';
import 'package:locadeserta/import_gladstories_view.dart';
import 'package:locadeserta/main_menu.dart';
import 'package:locadeserta/login_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';

void main() async {
  await FlutterStatusbarcolor.setStatusBarColor(Colors.black);
  runApp(LocaDesertaApp());
}

final Auth auth = Auth();

class LocaDesertaApp extends StatefulWidget {
  @override
  _LocaDesertaAppState createState() => _LocaDesertaAppState();
}

class _LocaDesertaAppState extends State<LocaDesertaApp> {
  Locale locale = Locale('uk');

  final ThemeData theme = ThemeData(
      primaryColor: Colors.black,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      fontFamily: 'Roboto',
      textTheme: TextTheme(title: TextStyle(color: Colors.white)));

  @override
  Widget build(BuildContext context) {
    return InheritedAuth(
      auth: auth,
      child: MaterialApp(
        locale: locale,
        title: 'Loca Deserta',
        theme: theme,
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => LoginView(
            onContinue: () => Navigator.pushNamed(context, "/main_menu"),
            onSetLocale: _onLocaleSet,
          ),
          "/main_menu": (context) => MainMenu(),
          ExtractCatalogViewArguments.routeName: (context) =>
              ExtractCatalogViewArguments(),
          ExtractExportPdfViewArguments.routeName: (context) =>
              ExtractExportPdfViewArguments(),
          ExtractExportGladStoriesPdfViewArguments.routeName: (context) =>
              ExtractExportGladStoriesPdfViewArguments(),
          "/create": (context) => CreateView(),
          ExtractEditStoryViewArguments.routeName: (context) =>
              ExtractEditStoryViewArguments(),
          ExtractArgumentsGameView.routeName: (context) =>
              ExtractArgumentsGameView(),
          ExtractEditPassageView.routeName: (context) => ExtractEditPassageView(),
          ImportGladStoryView.routeName: (context) => ImportGladStoryView(),
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
      ),
    );
  }

  void _onLocaleSet(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }
}
