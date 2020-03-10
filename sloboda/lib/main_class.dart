import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sloboda/views/city_buildings/city_building_built.dart';
import 'package:sloboda/views/city_game.dart';
import 'package:sloboda/views/city_props_view.dart';
import 'package:sloboda/views/create_sloboda.dart';
import 'package:sloboda/views/nature_resource_buildings.dart';
import 'package:sloboda/views/resource_buildings/resource_building_built.dart';
import 'package:sloboda/views/resource_buildings/resource_building_view.dart';
import 'package:sloboda/views/resource_view.dart';
import 'package:sloboda/views/shooting_range_view.dart';
import 'package:sloboda/views/sich/sich_view.dart';

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
  primaryColor: Colors.grey[300],
  backgroundColor: Colors.grey[300],
  scaffoldBackgroundColor: Colors.grey[300],
  accentColor: Colors.black,
  fontFamily: 'Roboto',
  unselectedWidgetColor: Colors.black,
  textTheme: TextTheme(
    bodyText2: TextStyle(
      fontFamily: "Raleway",
      fontSize: 16,
      color: Colors.black,
    ),
    headline6: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    ),
    button: TextStyle(
      fontFamily: 'Raleway-Bold',
      fontSize: 24.0,
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
      title: 'Sloboda - City Building Game Set in Ukraine XVII century',
      theme: whiteTheme,
      initialRoute: CreateSlobodaView.routeName,
      debugShowCheckedModeBanner: false,
      routes: {
        CreateSlobodaView.routeName: (context) => CreateSlobodaView(),
        CityGame.routeName: (context) => ExtractCityGameArguments(),
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
        ShootingRangeBuilt.routeName: (context) =>
            ExtractShootingRangeBuiltArguments(),
        CityPropScreen.routeName: (context) => ExtractCityPropScreenArguments(),
        SichScreen.routeName: (context) => ExtractSichScreenArguments(),
      },
    );
  }
}
