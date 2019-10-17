import 'package:flutter/material.dart';
import 'RouteGenerator.dart';
import 'package:firebase/firebase.dart';

void main() {
  initializeApp(
    apiKey: "AIzaSyAU4hCgQfLc_uO_tgWxKtvaHxsVExelIuQ",
    authDomain: "dike-pole-1548444278704.firebaseapp.com",
    databaseURL: "https://dike-pole-1548444278704.firebaseio.com",
    projectId: "dike-pole-1548444278704",
    storageBucket: "dike-pole-1548444278704.appspot.com",
    messagingSenderId: "874237405817",
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData(
      primaryColor: Colors.black,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      fontFamily: 'Roboto',
      textTheme: TextTheme(title: TextStyle(color: Colors.white)));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
