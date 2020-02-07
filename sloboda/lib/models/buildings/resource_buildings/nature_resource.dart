import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda_localizations.dart';

enum NATURAL_RESOURCES { RIVER, FOREST }

class NaturalResource with Producable {
  NATURAL_RESOURCES type;
  RESOURCE_TYPES produces;

  String getIconPath() {
    return 'images/resource_buildings/mill.png';
  }

  String toLocalizedString() {
    throw 'Must be implemented by a child';
  }
}

class Forest extends NaturalResource {
  NATURAL_RESOURCES type = NATURAL_RESOURCES.FOREST;
  int maxWorkers = 100;
  int workMultiplier = 2;
  RESOURCE_TYPES produces = RESOURCE_TYPES.WOOD;
  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 1,
  };

  String getIconPath() {
    return 'images/resource_buildings/forest.png';
  }

  String getKey() {
    return 'natureResources.forest';
  }

  String toLocalizedString() {
    return SlobodaLocalizations.getForKey(getKey());
  }
}

class River extends NaturalResource {
  NATURAL_RESOURCES type = NATURAL_RESOURCES.RIVER;
  int maxWorkers = 50;
  int workMultiplier = 2;
  RESOURCE_TYPES produces = RESOURCE_TYPES.FISH;
  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 1,
  };

  String getIconPath() {
    return 'images/resource_buildings/river.png';
  }

  String getKey() {
    return 'natureResources.river';
  }

  String toLocalizedString() {
    return SlobodaLocalizations.getForKey(getKey());
  }
}
