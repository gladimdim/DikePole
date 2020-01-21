import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class FishingPool extends ResourceBuilding {
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.POOL;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 5,
  };

  int workMultiplier = 5;

  RESOURCE_TYPES produces = RESOURCE_TYPES.FISH;
}