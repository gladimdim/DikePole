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
}

class StoryItemImage {
  final PassageTypes type = PassageTypes.IMAGE;
  final ImageType imageType;
  final List<String> value;

  StoryItemImage(this.value, this.imageType);

  @override
  String toJson() {
    return JsonEncoder.withIndent("  ").convert({
      "imageType": imageType.toString(),
      "value": value.toString(),
      "type": type.toString()
    });
  }
}

class StoryItemText {
  final PassageTypes type = PassageTypes.TEXT;
  final String value;

  StoryItemText(this.value);

  @override
  String toJson() {
    return JsonEncoder.withIndent("  ").convert({
      "value": value,
      "type": type.toString()
    });
  }
}

enum PassageTypes { IMAGE, TEXT }
