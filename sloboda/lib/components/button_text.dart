import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  final String text;

  ButtonText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.button,
    );
  }
}
