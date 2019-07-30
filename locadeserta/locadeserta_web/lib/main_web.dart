import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/main_view_web.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale = Locale('en');

  final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    backgroundColor: Colors.white,
    accentColor: Colors.black,
    fontFamily: 'Monaco',
    toggleableActiveColor: Colors.black,
    textTheme: TextTheme(
      title: TextStyle(color: Colors.black, fontFamily: 'Monaco', fontSize: 24.0),
      button: TextStyle(color: Colors.white, fontFamily: 'Monaco', fontSize: 32.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => MainView(
            onContinue: () => Navigator.pushNamed(context, "/main_menu"),
            onSetLocale: _onLocaleSet,
            locale: locale),
      },
      locale: locale,
      title: 'Loca Deserta',
      theme: theme,
      debugShowCheckedModeBanner: false,
    );
  }

  void _onLocaleSet(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }
}
