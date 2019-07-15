class PassageItemFactory {

  static fromType(PassageTypes type, {text, image}) {
    switch (type) {
      case PassageTypes.IMAGE: return PassageItemImage(image);
      case PassageTypes.TEXT: return PassageItemText(text);
    }
  }
}

class PassageItemText implements PassageItem {
  PassageTypes type = PassageTypes.TEXT;
  var value;
  PassageItemText(this.value);
}

class PassageItemImage implements PassageItem {
  PassageTypes type = PassageTypes.IMAGE;
  var value;
  PassageItemImage(this.value);
}

abstract class PassageItem {
  PassageTypes type;
  var value;
}

enum PassageTypes { IMAGE, TEXT }