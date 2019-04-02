import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/catalog_view.dart';

class LandingView extends StatefulWidget {
  final Function onStartGamePressed;

  LandingView({this.onStartGamePressed});

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  Widget build(BuildContext context) {
    return _buildLandingListView(context);
  }

  void _onViewCatalogPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CatalogView())
    );
  }

  ListView _buildLandingListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0),
          child: Card(
            color: Colors.white70,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image(
                      image: AssetImage("images/background/landing_1.jpg"),
                      fit: BoxFit.fill,
                      height: 200.0),
                ),
                ListTile(
                    title: Text(
                  "У вас є збережена гра",
                  style: TextStyle(fontSize: 20.0),
                )),
                ButtonTheme.bar(
                    child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        onPressed: widget.onStartGamePressed,
                        child: Text(
                          "Продовжити",
                          style: TextStyle(fontSize: 16.0),
                        ))
                  ],
                ))
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0),
          child: Card(
            color: Colors.white70,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image(
                      image: AssetImage("images/background/landing_0.jpg"),
                      fit: BoxFit.fill,
                      height: 200.0),
                ),
                ListTile(
                    title: Text(
                  "Каталог ігор",
                  style: TextStyle(fontSize: 20.0),
                )),
                ButtonTheme.bar(
                    child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () => _onViewCatalogPressed(context),
                        child: Text(
                          "Переглянути",
                          style: TextStyle(fontSize: 16.0),
                        ))
                  ],
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
