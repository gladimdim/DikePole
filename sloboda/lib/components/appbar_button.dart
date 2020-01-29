import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final Widget child;

  AppBarButton({this.onTap, this.color, this.child});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: color,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: child),
      ),
    );
  }
}
