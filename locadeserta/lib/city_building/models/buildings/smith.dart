import 'package:locadeserta/city_building/models/buildings/building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class Smith extends Building {
  static Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.WOOD: 3,
    RESOURCE_TYPES.STONE: 3,
  };
  RESOURCE_TYPES produces = RESOURCE_TYPES.FIREARM;
}