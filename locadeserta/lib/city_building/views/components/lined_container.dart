import 'package:flutter/material.dart';

class LineContainer extends StatelessWidget {
  final Widget child;

  LineContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[900],
              style: BorderStyle.solid,
              width: 0.5,
            ),
          ),

        ),
        child: child);
  }
}
