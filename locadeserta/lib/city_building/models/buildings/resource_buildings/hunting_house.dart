import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class TrapperHouse extends ResourceBuilding {
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 3,
    RESOURCE_TYPES.WOOD: 15,
  };

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 5,
  };
  int maxWorkers = 1;
  int workMultiplier = 2;

  RESOURCE_TYPES produces = RESOURCE_TYPES.FUR;
}