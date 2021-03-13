import 'package:flutter/material.dart';
import 'package:locadeserta/components/dash_painter.dart';

class SeparatorWithButton extends StatelessWidget {
  late final Widget button;
  SeparatorWithButton({
    button,
  }) {
    this.button = button ?? Container();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            foregroundPainter: DashPainter(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        button,
      ],
    );
  }
}
