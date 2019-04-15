import 'package:flutter/material.dart';
import 'package:locadeserta/LandingView.dart';

void main() => runApp(LocaDesertaApp());

class LocaDesertaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Дике Поле',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        backgroundColor: Colors.yellow[50],
        accentColor: Colors.black,
        fontFamily: 'Montserrat',
      ),
      home: HomeWidget(title: 'Дике Поле. Початок легенд.'),
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
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: LandingView());
  }
}
