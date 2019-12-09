import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locadeserta/InheritedAuth.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:locadeserta/creator/components/editing_user_stories_view.dart';
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

class _LocaDesertaAppState extends State<LocaDesertaApp> {
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
          EditingUserStoriesView.routeName: (context) =>
              EditingUserStoriesView(),
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
