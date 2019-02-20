import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LandingView extends StatefulWidget {
  final Function onStartGamePressed;
  LandingView({this.onStartGamePressed});
  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          color: Colors.black,
          textColor: Colors.red,
          onPressed: widget.onStartGamePressed,
          child: Text("Почати гру"),
        ),
      ),
    );
  }
}
