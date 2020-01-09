import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class Smith extends ResourceBuilding {
  static Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.WOOD: 3,
    RESOURCE_TYPES.STONE: 3,
  };
  RESOURCE_TYPES produces = RESOURCE_TYPES.FIREARM;
}