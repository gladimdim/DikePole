import 'package:flutter/material.dart';

class GameViewScaffold extends StatelessWidget {
  final Widget child;
  final Widget appBar;

  GameViewScaffold({this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Stack(
          children: <Widget>[child, appBar],
        ),
      ),
    );
  }
}
