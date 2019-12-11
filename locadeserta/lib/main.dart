import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locadeserta/InheritedAuth.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:locadeserta/creator/components/user_stories_list_view.dart';
import 'package:locadeserta/creator/components/edit_node_sequence_view.dart';
import 'package:locadeserta/creator/components/edit_story.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/creator/components/user_story_details_view.dart';
import 'package:locadeserta/export_pdf_view.dart';
import 'package:locadeserta/import_gladstories_view.dart';
import 'package:locadeserta/main_menu.dart';
import 'package:locadeserta/login_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'StatisticsView.dart';

void main() {
  runApp(LocaDesertaApp());
}

final Auth auth = Auth();

class LocaDesertaApp extends StatefulWidget {
  @override
  _LocaDesertaAppState createState() => _LocaDesertaAppState();
}

var blackTheme = ThemeData(
  primaryColor: Colors.white,
  backgroundColor: Colors.black,
  accentColor: Colors.white,
  fontFamily: 'Roboto',
  unselectedWidgetColor: Colors.white,
  textTheme: TextTheme(
    body1: TextStyle(
      fontFamily: "Raleway-Bold",
      fontSize: 18,
      color: Colors.white,
    ),
    title: TextStyle(
      color: Colors.white,
      fontFamily: 'Roboto',
    ),
    button: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.black,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
);

var whiteTheme = ThemeData(
  primaryColor: Colors.black,
  backgroundColor: Colors.white,
  accentColor: Colors.black,
  fontFamily: 'Roboto',
  unselectedWidgetColor: Colors.black,
  textTheme: TextTheme(
    body1: TextStyle(
      fontFamily: "Raleway-Bold",
      fontSize: 18,
      color: Colors.black,
    ),
    title: TextStyle(color: Colors.black),
    button: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
);

class _LocaDesertaAppState extends State<LocaDesertaApp> {
  final ThemeData theme = whiteTheme;

  @override
  Widget build(BuildContext context) {
    return InheritedAuth(
      auth: auth,
      child: MaterialApp(
        title: 'Loca Deserta',
        theme: theme,
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => LoginView(
                onContinue: () => Navigator.pushNamed(
                  context,
                  MainMenu.routeName,
                ),
                onSetLocale: _onLocaleSet,
              ),
          MainMenu.routeName: (context) => MainMenu(),
          ExtractCatalogViewArguments.routeName: (context) =>
              ExtractCatalogViewArguments(),
          ExtractExportPdfViewArguments.routeName: (context) =>
              ExtractExportPdfViewArguments(),
          ExtractExportGladStoriesPdfViewArguments.routeName: (context) =>
              ExtractExportGladStoriesPdfViewArguments(),
          UserStoriesList.routeName: (context) => UserStoriesList(),
          ExtractEditStoryViewArguments.routeName: (context) =>
              ExtractEditStoryViewArguments(),
          ExtractArgumentsGameView.routeName: (context) =>
              ExtractArgumentsGameView(),
          ExtractEditPassageView.routeName: (context) =>
              ExtractEditPassageView(),
          ImportGladStoryView.routeName: (context) => ImportGladStoryView(),
          StatisticsView.routeName: (context) => StatisticsView(),
          UserStoryDetailsView.routeName: (context) => InheritedAuth(
                child: ExtractUserStoryDetailsViewArguments(),
                auth: auth,
              ),
        },
      ),
    );
  }

  void _onLocaleSet(Locale newLocale) {
    setState(() {
      LDLocalizations.locale = newLocale;
    });
  }
}
