import 'dart:math';

import 'package:flutter/material.dart';

class BackgroundImage {
  static final BackgroundImage _bgImage = BackgroundImage._internal();

  BackgroundImage._internal();

  static ImageType variableToImageType(String variable) {
    var imageType = variable.split(" ")[1];
    switch (imageType) {
      case "forest":
        return ImageType.FOREST;
      case "bulrush":
        return ImageType.BULRUSH;
      case "boat":
        return ImageType.BOAT;
      default:
        return ImageType.BOAT;
    }
  }

  factory BackgroundImage() => _bgImage;
  static Map<ImageType, RandomImage> images = {
    ImageType.BOAT: RandomImage(ImageType.BOAT),
    ImageType.STEPPE: RandomImage(ImageType.FOREST),
    ImageType.FOREST: RandomImage(ImageType.FOREST),
    ImageType.BULRUSH: RandomImage(ImageType.BULRUSH),
  };

  static AssetImage getAssetImageForType(ImageType type) {
    return images[type].getAssetImage();
  }

  static AssetImage getColoredAssetImageForType(ImageType type) {
    return images[type].getAssetImageColored();
  }

  static void nextRandomForType(ImageType type) {
    return images[type].nextRandom();
  }

  static void resetRandomForType(ImageType type) {
    return images[type].resetUsedRandomNumbers();
  }
}

class RandomImage {
  Random _random = Random();
  int _currentRandom;
  int _MAX;
  List<int> _usedRandomNumbers;
  final ImageType type;

  Map<ImageType, String> _imagePrefix = {
    ImageType.BULRUSH: "bulrush",
    ImageType.FOREST: "forest",
    ImageType.STEPPE: "steppe",
    ImageType.BOAT: "boat",
  };

  RandomImage(this.type) {
    switch (type) {
      case ImageType.BOAT:
        _MAX = 15;
        break;
      case ImageType.FOREST:
        _MAX = 10;
        break;
      case ImageType.BULRUSH:
        _MAX = 12;
        break;
      default:
        throw "Not implemented";
        break;
    }

    _currentRandom = _random.nextInt(_MAX);
    _usedRandomNumbers = [];
  }

  AssetImage getAssetImage() {
    return AssetImage(
      "images/background/${_imagePrefix[type]}/${_currentRandom.toString()}.jpg",
    );
  }

  AssetImage getAssetImageColored() {
    return AssetImage(
      "images/background/${_imagePrefix[type]}/c_${_currentRandom.toString()}.jpg",
    );
  }

  void nextRandom() {
    if (_usedRandomNumbers.length == _MAX) {
      _usedRandomNumbers = [];
    }
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

enum ImageType { BOAT, STEPPE, FOREST, BULRUSH }
