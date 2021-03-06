import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locadeserta/creator/components/edit_node_sequence_view.dart';
import 'package:locadeserta/creator/components/edit_story.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/creator/components/share_to_pdf_screen.dart';
import 'package:locadeserta/creator/components/user_stories_list_view.dart';
import 'package:locadeserta/creator/components/user_story_details_view.dart';
import 'package:locadeserta/export_pdf_view.dart';
import 'package:locadeserta/import_gladstories_view.dart';
import 'package:locadeserta/login_view.dart';
import 'package:locadeserta/main_menu.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/app_preferences.dart';
import 'package:locadeserta/story_details_view.dart';
import 'package:locadeserta/views/purgatory_list_view.dart';

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
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(
      fontFamily: "Raleway-Bold",
      fontSize: 18,
      color: Colors.white,
    ),
    headline6: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
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
  hintColor: Colors.white,
  focusColor: Colors.yellow,
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.black,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  canvasColor: Colors.black,
);

var whiteTheme = ThemeData(
  primaryColor: Colors.black,
  backgroundColor: Colors.white,
  accentColor: Colors.black,
  fontFamily: 'Roboto',
  unselectedWidgetColor: Colors.black,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
    ),
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(
      fontFamily: "Raleway-Bold",
      fontSize: 18,
      color: Colors.black,
    ),
    headline6: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    ),
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
  canvasColor: Colors.white,
);

class _LocaDesertaAppState extends State<LocaDesertaApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AppPreferences.instance.init(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              title: 'Loca Deserta',
              theme: AppPreferences.instance.getDarkTheme()
                  ? blackTheme
                  : whiteTheme,
              initialRoute: "/",
              debugShowCheckedModeBanner: false,
              routes: {
                "/": (context) => LoginView(
                      onContinue: () => Navigator.pushNamed(
                        context,
                        MainMenu.routeName,
                      ),
                      darkTheme: AppPreferences.instance.getDarkTheme(),
                      onSetLocale: _onLocaleSet,
                      onThemeChange: (bool isDark) async {
                        await AppPreferences.instance.setDarkTheme(isDark);
                        setState(() {});
                      },
                    ),
                MainMenu.routeName: (context) => MainMenu(),
                ExtractStoryDetailsViewArguments.routeName: (context) =>
                    ExtractStoryDetailsViewArguments(),
                // ExtractExportPdfViewArguments.routeName: (context) =>
                //     ExtractExportPdfViewArguments(),
                // ExtractExportGladStoriesPdfViewArguments.routeName: (context) =>
                //     ExtractExportGladStoriesPdfViewArguments(),
                UserStoriesList.routeName: (context) => UserStoriesList(),
                ExtractEditStoryViewArguments.routeName: (context) =>
                    ExtractEditStoryViewArguments(),
                ExtractArgumentsGameView.routeName: (context) =>
                    ExtractArgumentsGameView(),
                ExtractEditPassageView.routeName: (context) =>
                    ExtractEditPassageView(),
                ImportGladStoryView.routeName: (context) =>
                    ImportGladStoryView(),
                UserStoryDetailsView.routeName: (context) =>
                    ExtractUserStoryDetailsViewArguments(),
                ShareUserStoryToPdf.routeName: (context) =>
                    ExtractPlublishStoryViewArguments(),
                PurgatoryListView.routeName: (context) => PurgatoryListView(),
              },
            );
          } else {
            return Container();
          }
        });
  }

  void _onLocaleSet(Locale newLocale) {
    setState(() {
      LDLocalizations.locale = newLocale;
    });
  }
}
