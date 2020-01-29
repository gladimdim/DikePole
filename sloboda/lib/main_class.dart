import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sloboda/views/city_buildings/city_building_built.dart';
import 'package:sloboda/views/city_game.dart';
import 'package:sloboda/views/nature_resource_buildings.dart';
import 'package:sloboda/views/resource_buildings/resource_building_built.dart';
import 'package:sloboda/views/resource_buildings/resource_building_view.dart';
import 'package:sloboda/views/resource_view.dart';

class SlobodaApp extends StatefulWidget {
  @override
  _SlobodaAppState createState() => _SlobodaAppState();
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
  textTheme: TextTheme(
    body1: TextStyle(
      fontFamily: "Raleway-Bold",
      fontSize: 18,
      color: Colors.black,
    ),
    title: TextStyle(
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

class _SlobodaAppState extends State<SlobodaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loca Deserta',
      theme: whiteTheme,
      initialRoute: CityGame.routeName,
      debugShowCheckedModeBanner: false,
      routes: {
        CityGame.routeName: (context) => CityGame(),
        ResourceBuildingBuilt.routeName: (context) =>
            ExtractResourceBuildingBuiltArguments(),
        ResourceDetailsScreen.routeName: (context) =>
            ExtractResourceDetailsScreenArguments(),
        ResourceBuildingDetailsScreen.routeName: (context) =>
            ExtractResourceBuildingDetailsScreenArguments(),
        CityBuildingBuilt.routeName: (context) =>
            ExtractCityBuildingBuiltArguments(),
        NatureResourceBuildingScreen.routeName: (context) =>
            ExtractNatureResourceBuildingArguments(),
      },
    );
  }
}
