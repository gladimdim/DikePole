import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final String text;

  AppBarButton({required this.onTap, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      // splashColor: color,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
