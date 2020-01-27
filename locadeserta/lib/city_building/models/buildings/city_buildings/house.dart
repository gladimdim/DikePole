import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class House extends CityBuilding {
  CITY_BUILDING_TYPES type = CITY_BUILDING_TYPES.HOUSE;
  CITY_PROPERTIES produces = CITY_PROPERTIES.CITIZENS;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 10,
    RESOURCE_TYPES.STONE: 3,
    RESOURCE_TYPES.WOOD: 10,
  };
}