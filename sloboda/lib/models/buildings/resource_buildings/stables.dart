import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class Stables extends ResourceBuilding {
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.STABLES;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 5,
    RESOURCE_TYPES.WOOD: 5,
  };

  int workMultiplier = 2;

  ResourceType produces = Horse();

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 10,
  };
}