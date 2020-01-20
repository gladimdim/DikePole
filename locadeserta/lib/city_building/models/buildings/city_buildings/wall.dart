import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class Wall extends CityBuilding {
  CITY_PROPERTIES produces = CITY_PROPERTIES.DEFENSE;

  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 20,
    RESOURCE_TYPES.WOOD: 100,
  };
}