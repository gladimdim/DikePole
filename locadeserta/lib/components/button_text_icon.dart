import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonTextIcon extends StatelessWidget {
  final String text;
  final Icon icon;
  final Color? color;
  final VoidCallback onTap;

  ButtonTextIcon(
      {required this.text,
      required this.icon, this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: color,
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(color: color),
          ),
          icon
        ],
      ),
      onTap: onTap,
    );
  }
}
