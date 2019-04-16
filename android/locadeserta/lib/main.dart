import 'package:flutter/material.dart';
import 'package:locadeserta/LandingView.dart';
import 'package:locadeserta/models/Auth.dart';

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
  final Auth auth = Auth();

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
                "Вийти",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => widget.auth.signOut(),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: LandingView(
          auth: widget.auth,
        ));
  }
}
