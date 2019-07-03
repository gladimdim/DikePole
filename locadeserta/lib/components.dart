import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

var optionBox = (BuildContext context, String text) => SizedBox(
      height: 100.0,
      child: Container(
        color: Colors.black,
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
