import 'package:flutter/material.dart';

class SoftContainer extends StatelessWidget {
  final Widget child;
  final bool onlyTop;
  final double borderRadiusValue;

  const SoftContainer(
      {Key key,
      this.child,
      this.onlyTop = false,
      this.borderRadiusValue = 40.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
//          shape: BoxShape.rectangle,
        borderRadius: onlyTop
            ? BorderRadius.only(
                topLeft: Radius.circular(borderRadiusValue),
                topRight: Radius.circular(borderRadiusValue))
            : BorderRadius.all(
                Radius.circular(borderRadiusValue),
              ),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[600],
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: .3),
          BoxShadow(
              color: Colors.white,
              offset: Offset(-4.0, -4.0),
              blurRadius: 15.0,
              spreadRadius: 0.3)
        ],
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey[100],
            Colors.grey[200],
            Colors.grey[300],
            Colors.grey[300],
          ],
          stops: [0.1, 0.6, 0.8, 0.9],
        ),
      ),
      child: child,
    );
  }
}
