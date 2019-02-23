import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class LandingView extends StatefulWidget {
  final Function onStartGamePressed;

  LandingView({this.onStartGamePressed});

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        child: GridView.builder(
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            padding: EdgeInsets.all(4.0),
            itemCount: 8,
            itemBuilder: (context, index) {
              return Image.asset("images/background/boat_${index}.jpg",
                  fit: BoxFit.cover);
            }),
      ),
      Center(
        child: RaisedButton(
          color: Colors.black,
          textColor: Colors.red,
          onPressed: widget.onStartGamePressed,
          child: Text("Почати гру"),
        ),
      )
    ]);
  }
}
