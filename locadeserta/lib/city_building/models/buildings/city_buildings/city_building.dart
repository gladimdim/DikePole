import 'package:locadeserta/city_building/models/buildings/city_buildings/church.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/house.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/tower.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/watch_tower.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

abstract class CityBuilding {
  CITY_BUILDING_TYPES type;
  static Map<RESOURCE_TYPES, int> requiredToBuild;

  CITY_PROPERTIES produces;

  static fromType(CITY_BUILDING_TYPES type) {
    switch (type) {
      case CITY_BUILDING_TYPES.CHURCH: return Church();
      case CITY_BUILDING_TYPES.HOUSE: return House();
      case CITY_BUILDING_TYPES.TOWER: return Tower();
      case CITY_BUILDING_TYPES.WATCH_TOWER: return WatchTower();
    }
  }

}

enum CITY_BUILDING_TYPES { HOUSE, CHURCH, TOWER, WATCH_TOWER }

enum CITY_PROPERTIES { FAITH, DEFENSE, GLORY, CITIZENS }

String cityBuildingTypeToString(CITY_BUILDING_TYPES type) {
  switch (type) {
    case CITY_BUILDING_TYPES.WATCH_TOWER: return 'Watch Tower';
    case CITY_BUILDING_TYPES.TOWER: return 'Tower';
    case CITY_BUILDING_TYPES.HOUSE: return 'House';
    case CITY_BUILDING_TYPES.CHURCH: return 'Church';
  }
}

String cityTypeToIconPath(CITY_BUILDING_TYPES type) {
  switch (type) {
    case CITY_BUILDING_TYPES.WATCH_TOWER: return 'images/city_building/city_buildings/kurin.png';
    case CITY_BUILDING_TYPES.TOWER: return'images/city_building/city_buildings/kurin.png';
    case CITY_BUILDING_TYPES.HOUSE: return 'images/city_building/city_buildings/kurin.png';
    case CITY_BUILDING_TYPES.CHURCH: return 'images/city_building/city_buildings/kurin.png';
  }
}