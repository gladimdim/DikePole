import 'package:flutter/material.dart';

class VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(32, Axis.vertical);
  }
}

class HDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(32, Axis.horizontal);
  }
}

class Divider extends StatelessWidget {
  final double size;
  final Axis direction;

  Divider(this.size, this.direction);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: direction == Axis.vertical ? size : null,
      width: direction == Axis.horizontal ? size : null,
    );
  }
}
