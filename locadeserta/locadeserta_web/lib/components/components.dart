import 'package:flutter_web/material.dart';

var optionBox = (BuildContext context, String text, double height) => SizedBox(
      height: height != 0 ? height : MediaQuery.of(context).size.height * 0.075,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.button.color),
          ),
        ),
      ),
    );

var styledButton = (BuildContext context, String text) => optionBox(context, text, 50.0);
