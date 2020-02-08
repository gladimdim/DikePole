import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class PowderCellar extends ResourceBuilding {
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.POWDER_CELLAR;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 5,
    RESOURCE_TYPES.WOOD: 5,
    RESOURCE_TYPES.STONE: 2,
  };

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 3,
  };

  int workMultiplier = 2;

  int maxWorkers = 3;

  RESOURCE_TYPES produces = RESOURCE_TYPES.POWDER;
}