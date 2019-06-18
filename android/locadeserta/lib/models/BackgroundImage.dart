import 'dart:math';

import 'package:flutter/material.dart';

// from inkle:
// image: bulrush; image boat; image river; image cossacks, image fight, image steppe, image forest
class BackgroundImage {
  factory BackgroundImage() => _bgImage;
  static final BackgroundImage _bgImage = BackgroundImage._internal();

  BackgroundImage._internal();

  static Map<ImageType, RandomImage> _images = {
    ImageType.BOAT: RandomImage(ImageType.BOAT),
    ImageType.STEPPE: RandomImage(ImageType.RIVER), // shadowed
    ImageType.FOREST: RandomImage(ImageType.BOAT),
    ImageType.BULRUSH: RandomImage(ImageType.BULRUSH),
    ImageType.RIVER: RandomImage(ImageType.RIVER),
    ImageType.LANDING: RandomImage(ImageType.LANDING),
    ImageType.CAMP: RandomImage(ImageType.CAMP),
    ImageType.COSSACKS: RandomImage(ImageType.CAMP), // shadowed

  };

  static ImageType imageTypeFromCurrentTags(List<String> variables) {
    var images = variables.where((variable) {
      var tagName = variable.split(" ")[0];
      return tagName == 'image';
    }).toList();

    var random = Random();

    var tagToTake = images[random.nextInt(images.length)];

    return BackgroundImage.variableToImageType(tagToTake);
  }

  static ImageType variableToImageType(String variable) {
    var imageType = variable.split(" ")[1];
    switch (imageType) {
      case "forest":
        return ImageType.FOREST;
      case "bulrush":
        return ImageType.BULRUSH;
      case "boat":
        return ImageType.BOAT;
      case "river":
        return ImageType.RIVER;
      case 'landing':
        return ImageType.LANDING;
      case 'camp':
        return ImageType.CAMP;
      case 'cossacks':
        return ImageType.COSSACKS;
      default:
        return ImageType.CAMP;
    }
  }

  static AssetImage getAssetImageForType(ImageType type) {
    return _images[type].getAssetImage();
  }

  static AssetImage getColoredAssetImageForType(ImageType type) {
    return _images[type].getAssetImageColored();
  }

  static void nextRandomForType(ImageType type) {
    return _images[type].nextRandom();
  }

  static void resetRandomForType(ImageType type) {
    return _images[type].resetUsedRandomNumbers();
  }
}

class RandomImage {
  Random _random = Random();
  int _currentRandom;
  int _max;
  List<int> _usedRandomNumbers;
  final ImageType type;

  Map<ImageType, String> _imagePrefix = {
    ImageType.BULRUSH: "bulrush",
    ImageType.FOREST: "forest",
    ImageType.STEPPE: "steppe",
    ImageType.BOAT: "boat",
    ImageType.RIVER: "river",
    ImageType.LANDING: 'landing',
    ImageType.CAMP: "camp",
    ImageType.COSSACKS: "cossacks",
  };

  RandomImage(this.type) {
    switch (type) {
      case ImageType.BOAT:
        _max = 18;
        break;
      case ImageType.FOREST:
        _max = 10;
        break;
      case ImageType.BULRUSH:
        _max = 12;
        break;
      case ImageType.RIVER:
        _max = 21;
        break;
      case ImageType.LANDING:
        _max = 8;
        break;
      case ImageType.CAMP:
        _max= 15;
        break;
      default:
        throw "Not implemented";
        break;
    }

    _currentRandom = _random.nextInt(_max);
    _usedRandomNumbers = [_currentRandom];
  }

  AssetImage getAssetImage() {
    var returnValue = AssetImage(
      "images/background/${_imagePrefix[type]}/${_currentRandom.toString()}.jpg",
    );
    return returnValue;
  }

  AssetImage getAssetImageColored() {
    return AssetImage(
      "images/background/${_imagePrefix[type]}/c_${_currentRandom.toString()}.jpg",
    );
  }

  void nextRandom() {
    if (_usedRandomNumbers.length == _max) {
      _usedRandomNumbers = [];
    }
    var temp = _random.nextInt(_max);
    if (_usedRandomNumbers.indexOf(temp) >= 0) {
      nextRandom();
      return;
    } else {
      _currentRandom = temp;
    }
    _usedRandomNumbers.add(_currentRandom);
  }

  void resetUsedRandomNumbers() {
    _usedRandomNumbers = [];
  }
}

enum ImageType { BOAT, STEPPE, FOREST, BULRUSH, RIVER, LANDING, CAMP, COSSACKS }
