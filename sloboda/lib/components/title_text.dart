import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  TitleText(this.text, {this.textAlign: TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline6,
      textAlign: textAlign,
    );
  }
}
