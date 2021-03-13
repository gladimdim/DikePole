import 'package:flutter/material.dart';
import 'package:locadeserta/components/dash_painter.dart';

class SeparatorWithButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;

  SeparatorWithButton({
    required this.onPressed,
    this.iconData = Icons.add_box_outlined,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          // height: 32,
          child: CustomPaint(
            foregroundPainter: DashPainter(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Container(
          width: 42,
          color: Theme.of(context).backgroundColor,
          child: Center(
            child: IconButton(
              icon: Icon(
                iconData,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}
