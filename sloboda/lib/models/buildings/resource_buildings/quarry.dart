import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class Quarry extends ResourceBuilding {
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.QUARRY;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 5,
    RESOURCE_TYPES.WOOD: 5,
  };

  int workMultiplier = 3;

  ResourceType produces = Stone();

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 2,
  };
}