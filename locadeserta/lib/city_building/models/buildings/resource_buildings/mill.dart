import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class Mill extends ResourceBuilding {
  BUILDING_TYPES type = BUILDING_TYPES.MILL;

  static Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 5,
    RESOURCE_TYPES.STONE: 5,
    RESOURCE_TYPES.WOOD: 5,
  };

  int workMultiplier = 2;

  RESOURCE_TYPES produces = RESOURCE_TYPES.MONEY;

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 5,
  };
}