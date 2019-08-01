import 'dart:convert';

import 'package:locadeserta/models/background_image.dart';

class StoryHistory {
  List _history;

  StoryHistory(List history) {
    _history = history;
  }

  static createItem(PassageTypes type, value, ImageType imageType) {
    switch (type) {
      case PassageTypes.TEXT:
        return StoryItemText(value);
      case PassageTypes.IMAGE:
        return StoryItemImage(value, imageType);
    }
  }

  addItem(passage) {
    _history.add(passage);
  }

  isEmpty() {
    return _history.isEmpty;
  }

  getLast() {
    return _history.last;
  }

  clear() {
    _history.clear();
  }

  List getHistory() {
    return _history;
  }

  toString() {
    var result;
    try {
      result = JsonEncoder.withIndent("  ").convert(_history);
    } catch (e) {
      print(e);
    }
    return result;
  }

  static fromString(String s) {
    var map = JsonDecoder().convert(s);
    var items = map.map((m) {
      var m1 = JsonDecoder().convert(m);
      if (m1["type"] == "PassageTypes.IMAGE") {
        return StoryItemImage.fromString(m);
      }
      if (m1["type"] == "PassageTypes.TEXT") {
        return StoryItemText.fromString(m);
      }

      return m1;
    }).toList();
    return StoryHistory(items);
  }
}

class StoryItemImage {
  final PassageTypes type = PassageTypes.IMAGE;
  final ImageType imageType;
  final List<String> value;

  StoryItemImage(this.value, this.imageType);

  String toJson() {
    return JsonEncoder.withIndent("  ").convert({
      "imageType": imageType.toString(),
      "value": JsonCodec().encode(value),
      "type": type.toString()
    });
  }

  static StoryItemImage fromString(String s) {
    var map = JsonDecoder().convert(s);
    var value = JsonDecoder().convert(map["value"]);
    var value2 = List<String>.from(value.map((v) => v.toString()).toList());
    var imageType = imageTypeFromString(map["imageType"]);
    return StoryItemImage(
      value2,
      imageType,
    );
  }
}

ImageType imageTypeFromString(String s) {
  switch (s) {
    case "ImageType.FOREST":
      return ImageType.FOREST;
    case "ImageType.RIVER":
      return ImageType.RIVER;
    case "ImageType.CAMP":
      return ImageType.CAMP;
    case "ImageType.LANDING":
      return ImageType.LANDING;
    case "ImageType.BULRUSH":
      return ImageType.BULRUSH;
    case "ImageType.COSSACKS":
      return ImageType.COSSACKS;
    case "ImageType.BOAT":
      return ImageType.BOAT;
    case "ImageType.STEPPE":
      return ImageType.STEPPE;
    default:
      return null;
  }
}

class StoryItemText {
  final PassageTypes type = PassageTypes.TEXT;
  final String value;

  StoryItemText(this.value);

  String toJson() {
    return JsonEncoder.withIndent("  ")
        .convert({"value": value, "type": type.toString()});
  }

  static StoryItemText fromString(String s) {
    var map = JsonDecoder().convert(s);
    return StoryItemText(
      map["value"],
    );
  }
}

enum PassageTypes { IMAGE, TEXT }
