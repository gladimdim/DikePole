import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class Church extends CityBuilding {
  CITY_PROPERTIES produces = CITY_PROPERTIES.FAITH;
  CITY_BUILDING_TYPES type = CITY_BUILDING_TYPES.CHURCH;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 100,
    RESOURCE_TYPES.STONE: 20,
    RESOURCE_TYPES.WOOD: 50,
    RESOURCE_TYPES.MONEY: 20
  };
}