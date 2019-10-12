import 'package:flutter/material.dart';

class BorderedContainer extends StatelessWidget {
  final Widget child;

  BorderedContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 3.0,
          ),
        ),
        child: child);
  }
}
