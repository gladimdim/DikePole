import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class IronMine extends ResourceBuilding {
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.IRON_MINE;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 10,
    RESOURCE_TYPES.WOOD: 15,
  };

  int workMultiplier = 3;

  RESOURCE_TYPES produces = RESOURCE_TYPES.IRON_ORE;

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 5,
  };
}