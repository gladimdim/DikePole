import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class Quarry extends ResourceBuilding {
  BUILDING_TYPES type = BUILDING_TYPES.QUARRY;
  static Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 5,
    RESOURCE_TYPES.WOOD: 5,
  };

  int workMultiplier = 3;

  RESOURCE_TYPES produces = RESOURCE_TYPES.STONE;
}