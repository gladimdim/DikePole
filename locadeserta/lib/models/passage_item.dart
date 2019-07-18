import 'package:flutter/foundation.dart';
import 'package:locadeserta/models/background_image.dart';

class PassageItem {
  PassageTypes type;
  var value;
  ImageType imageType;

  PassageItem({@required this.type, this.value, this.imageType});
}

enum PassageTypes { IMAGE, TEXT }
