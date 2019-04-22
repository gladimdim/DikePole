import 'dart:math';

import 'package:flutter/material.dart';

class BackgroundImage {
  static final BackgroundImage _bgImage = BackgroundImage._internal();
  BackgroundImage._internal();
  factory BackgroundImage() => _bgImage;

  final Random _boatRandom = Random();
  final int _boatMax = 14;

  AssetImage getAssetImageForType(String type) {
    return AssetImage(
        "images/background/boat_${_boatRandom.nextInt(_boatMax).toString()}.jpg");
  }
}