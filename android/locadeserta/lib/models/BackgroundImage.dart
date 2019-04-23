import 'dart:math';

import 'package:flutter/material.dart';

class BackgroundImage {
  static final BackgroundImage _bgImage = BackgroundImage._internal();
  BackgroundImage._internal();
  factory BackgroundImage() => _bgImage;
  static Map<ImageType, RandomImage> images = {
        ImageType.BOAT: BoatImages(),
        ImageType.STEPPE: BoatImages()
      };

  static final boatImage = BoatImages();

  static AssetImage getAssetImageForType(ImageType type) {
    return images[type].getAssetImage();
  }

  static void nextRandomForType(ImageType type) {
    return images[type].nextRandom();
  }

  static void resetRandomForType(ImageType type) {
    return images[type].resetUsedRandomNumbers();
  }
}

class BoatImages implements RandomImage {
  Random _random = Random();
  int _currentRandom;
  static const _MAX = 14;
  List<int> _usedRandomNumbers;

  BoatImages() {
    _currentRandom = _random.nextInt(_MAX);
    _usedRandomNumbers = [];
  }

  AssetImage getAssetImage() {
    return AssetImage(
        "images/background/boat_${_currentRandom.toString()}.jpg");
  }

  void nextRandom() {
    var temp = _random.nextInt(_MAX);
    if (_usedRandomNumbers.indexOf(temp) >= 0) {
      nextRandom();
    } else {
      _currentRandom = temp;
    }
  }

  void resetUsedRandomNumbers() {
    _usedRandomNumbers = [];
  }

}

abstract class RandomImage {
  Random _random;
  int _currentRandom;
  static const _MAX = 0;
  List<int> _usedRandomNumbers;
  AssetImage getAssetImage();
  void nextRandom();

  void resetUsedRandomNumbers();
}

enum ImageType {BOAT, STEPPE}
