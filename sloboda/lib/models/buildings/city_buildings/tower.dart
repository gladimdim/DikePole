import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class Tower extends CityBuilding {
  CITY_BUILDING_TYPES type = CITY_BUILDING_TYPES.TOWER;
  CITY_PROPERTIES produces = CITY_PROPERTIES.DEFENSE;

  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 100,
    RESOURCE_TYPES.STONE: 20,
    RESOURCE_TYPES.WOOD: 50,
    RESOURCE_TYPES.MONEY: 20
  };
}
