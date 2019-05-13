import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:locadeserta/LandingView.dart';
import 'package:locadeserta/LoginView.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';

void main() => runApp(LocaDesertaApp());

final Auth auth = Auth();

class LocaDesertaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loca Deserta',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        backgroundColor: Colors.white,
        accentColor: Colors.black,
        fontFamily: 'Montserrat',
      ),
      home: HomeWidget(title: "Loca Deserta"),
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
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          FlatButton(
            child: Text(
              LDLocalizations.of(context).signOut,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => auth.signOut(),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder<User>(
          stream: auth.onAuthStateChange,
          initialData: null,
          builder: (context, snapshot) {
            return snapshot.data == null
                ? LoginView(auth: auth)
                : LandingView(auth: auth);
          }),
    );
  }
}
