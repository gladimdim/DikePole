import 'package:flutter/widgets.dart';

BorderRadius getAllRoundedBorderRadius({double radius = 20}) {
  return BorderRadius.all(
    Radius.circular(radius),
  );
}

BorderRadius getTopRoundedBorderRadius() {
  return BorderRadius.only(
      topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0));
}