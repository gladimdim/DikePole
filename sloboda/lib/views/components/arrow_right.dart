import 'package:flutter/widgets.dart';
import 'dart:math';

class ArrowRight extends StatelessWidget {
  const ArrowRight({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset('images/ui/arrow_right.png', width: 32);
  }
}

class ArrowLeft extends StatelessWidget {
  const ArrowLeft({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi,
      child: Image.asset('images/ui/arrow_right.png', width: 32),
    );
  }
}
