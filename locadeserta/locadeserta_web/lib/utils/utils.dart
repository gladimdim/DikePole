import 'package:flutter_web_ui/ui.dart';

double widthThird(Size size) {
  return isSmall(size) ? size.width / 3 : size.height / 3;
}

double heightThird(Size size) {
  return isSmall(size) ? size.height / 3 : size.width / 3;
}

bool isSmall(Size size) {
  var smallest = smallestDimension(size);
  return smallest < 400;
}

bool isPortrait(Size size) {
  return size.height > size.width;
}

double smallestDimension(Size size) {
  print(size);
  return size.height > size.width ? size.width : size.height;
}