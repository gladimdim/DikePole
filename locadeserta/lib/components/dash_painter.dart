import 'package:flutter/material.dart';

class DashPainter extends CustomPainter {
  final Color color;
  final double dashSize;
  DashPainter({required this.color, this.dashSize = 10.0});

  @override
  void paint(Canvas canvas, Size size) {
    int dashes = size.width ~/ dashSize;

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    var i = -1;
    while (i++ < dashes) {
      double start = dashSize * i * 2;
      var end = start + dashSize;
      canvas.drawLine(Offset(start, 0), Offset(end, 0), paint);
    }
  }

  @override
  bool shouldRepaint(DashPainter old) {
    return old.color != color || old.dashSize != dashSize;
  }
}
