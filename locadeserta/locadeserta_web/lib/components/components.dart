import 'package:flutter_web/material.dart';

var optionBox = (BuildContext context, String text) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.075,
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
                color: Theme.of(context).textTheme.title.color),
          ),
        ),
      ),
    );
