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
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 5000,
            height: 5000,
            child: Image.asset(
              "images/background/landing_0.jpg",
              repeat: ImageRepeat.repeatY,
            ),
          ),
        ),
        Center(
          child: RaisedButton(
            color: Colors.black,
            textColor: Colors.red,
            onPressed: widget.onStartGamePressed,
            child: Text("Почати гру"),
          ),
        )
      ],
    );
  }
}
