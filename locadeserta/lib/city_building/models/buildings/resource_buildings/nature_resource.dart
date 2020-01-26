import 'package:locadeserta/city_building/models/abstract/producable.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

enum NATURAL_RESOURCES { RIVER, FOREST }

class NaturalResource with Producable {
  RESOURCE_TYPES produces;

  String getIconPath() {
    return 'images/city_building/resource_buildings/mill.png';
  }
}

class Forest extends NaturalResource {
  int maxWorkers = 100;
  int workMultiplier = 2;
  RESOURCE_TYPES produces = RESOURCE_TYPES.WOOD;
  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 1,
  };

  String getIconPath() {
    return 'images/city_building/resource_buildings/forest.png';
  }

  String toString() {
    return 'Forest';
  }
}

class River extends NaturalResource {
  int maxWorkers = 50;
  int workMultiplier = 2;
  RESOURCE_TYPES produces = RESOURCE_TYPES.FISH;
  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 1,
  };

  String getIconPath() {
    return 'images/city_building/resource_buildings/quarry.png';
  }

  String toString() {
    return 'River';
  }
}
