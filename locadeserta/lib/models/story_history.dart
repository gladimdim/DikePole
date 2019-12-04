import 'dart:convert';
import 'package:gladstoriesengine/gladstoriesengine.dart';

class StoryHistory {
  List _history;

  StoryHistory(List history) {
    _history = history;
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
        return HistoryItemImage.fromString(m);
      }
      if (m1["type"] == "PassageTypes.TEXT") {
        return HistoryItemText.fromString(m);
      }

      return m1;
    }).toList();
    return StoryHistory(items);
  }
}

class HistoryItemImage extends HistoryItemBase {
  final PassageTypes type = PassageTypes.IMAGE;
  final ImageType imageType;
  final List<String> value;

  HistoryItemImage(this.value, this.imageType);

  String toJson() {
    return JsonEncoder.withIndent("  ").convert({
      "imageType": imageType.toString(),
      "value": JsonCodec().encode(value),
      "type": type.toString()
    });
  }

  static HistoryItemImage fromString(String s) {
    var map = JsonDecoder().convert(s);
    var value = JsonDecoder().convert(map["value"]);
    var value2 = List<String>.from(value.map((v) => v.toString()).toList());
    var imageType = imageTypeFromString(map["imageType"]);
    return HistoryItemImage(
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

class HistoryItemText extends HistoryItemBase {
  final PassageTypes type = PassageTypes.TEXT;
  final String value;

  HistoryItemText(this.value);

  String toJson() {
    return JsonEncoder.withIndent("  ")
        .convert({"value": value, "type": type.toString()});
  }

  static HistoryItemText fromString(String s) {
    var map = JsonDecoder().convert(s);
    return HistoryItemText(
      map["value"],
    );
  }
}

abstract class HistoryItemBase {
  PassageTypes type;
  var value;
  String toJson();
  static fromString(String s) {}
}

enum PassageTypes { IMAGE, TEXT }
