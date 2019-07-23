import 'package:locadeserta/models/background_image.dart';

class StoryHistory {
  List _history;
  StoryHistory(List history) {
    this._history = history;
  }

  static createItem(PassageTypes type, value, ImageType imageType) {
    switch (type) {
      case PassageTypes.TEXT: return StoryItemText(value);
      case PassageTypes.IMAGE: return StoryItemImage(value, imageType);
    }
  }

  addItem(passage) {
    this._history.add(passage);
  }

  isEmpty() {
    return this._history.isEmpty;
  }

  getLast() {
    return this._history.last;
  }

  clear() {
    this._history.clear();
  }

  List getHistory() {
    return this._history;
  }
}

class StoryItemImage {
  final PassageTypes type = PassageTypes.IMAGE;
  final ImageType imageType;
  final List<String> value;

  StoryItemImage(this.value, this.imageType);
}

class StoryItemText {
  final PassageTypes type = PassageTypes.TEXT;
  final String value;

  StoryItemText(this.value);
}

enum PassageTypes { IMAGE, TEXT }
