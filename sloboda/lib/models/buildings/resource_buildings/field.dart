import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class Field extends ResourceBuilding {
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.FIELD;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 5,
  };

  int workMultiplier = 5;

  RESOURCE_TYPES produces = RESOURCE_TYPES.FOOD;
}