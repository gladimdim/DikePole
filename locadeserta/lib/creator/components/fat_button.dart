import 'package:flutter/material.dart';

class FatButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  FatButton({@required this.text, this.backgroundColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height*0.075;
    return SizedBox(
      height: height,
      child: Container(
        color: backgroundColor,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.title.color),
          ),
        ),
      ),
    );
  }
}
