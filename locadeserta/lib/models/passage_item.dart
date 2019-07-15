class PassageItem {
  PassageTypes type;
  var value;

  PassageItem({this.type, this.value});
}

enum PassageTypes { IMAGE, TEXT }