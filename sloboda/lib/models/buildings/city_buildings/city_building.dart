import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/buildings/city_buildings/church.dart';
import 'package:sloboda/models/buildings/city_buildings/house.dart';
import 'package:sloboda/models/buildings/city_buildings/tower.dart';
import 'package:sloboda/models/buildings/city_buildings/wall.dart';
import 'package:sloboda/models/buildings/city_buildings/watch_tower.dart';
import 'package:sloboda/models/resources/resource.dart';

abstract class CityBuilding implements Buildable<RESOURCE_TYPES> {
  CITY_BUILDING_TYPES type;
  Map<RESOURCE_TYPES, int> requiredToBuild;

  CITY_PROPERTIES produces;

  int outputAmount = 1;

  static CityBuilding fromType(CITY_BUILDING_TYPES type) {
    switch (type) {
      case CITY_BUILDING_TYPES.CHURCH:
        return Church();
      case CITY_BUILDING_TYPES.HOUSE:
        return House();
      case CITY_BUILDING_TYPES.TOWER:
        return Tower();
      case CITY_BUILDING_TYPES.WATCH_TOWER:
        return WatchTower();
      case CITY_BUILDING_TYPES.WALL:
        return Wall();
      default: throw 'Building $type is not recognized';
    }
  }

  Map<CITY_PROPERTIES, int> generate() {
    return Map.fromEntries([MapEntry(produces, outputAmount)]);
  }
}

enum CITY_BUILDING_TYPES { HOUSE, CHURCH, TOWER, WATCH_TOWER, WALL }

String cityTypeToString (CITY_BUILDING_TYPES type) {
  switch (type) {
    case CITY_BUILDING_TYPES.WALL: return 'Wall';
    case CITY_BUILDING_TYPES.CHURCH: return 'Church';
    case CITY_BUILDING_TYPES.HOUSE: return 'House';
    case CITY_BUILDING_TYPES.TOWER: return 'Tower';
    case CITY_BUILDING_TYPES.WATCH_TOWER: return 'Watch Tower';
    default: throw 'Building $type is not recognized';
  }
}

enum CITY_PROPERTIES { FAITH, DEFENSE, GLORY, CITIZENS }

String cityPropertiesToString(CITY_PROPERTIES prop) {
  switch (prop) {
    case CITY_PROPERTIES.CITIZENS:
      return 'Citizens';
    case CITY_PROPERTIES.DEFENSE:
      return 'Defense';
    case CITY_PROPERTIES.FAITH:
      return 'Faith';
    case CITY_PROPERTIES.GLORY:
      return 'Glory';
    default: throw 'City prop $prop is not recognized';
  }
}

String cityPropertiesToIconPath(CITY_PROPERTIES prop) {
  switch (prop) {
    case CITY_PROPERTIES.CITIZENS:
      return 'images/city_buildings/citizen_64.png';
    case CITY_PROPERTIES.DEFENSE:
      return 'images/city_buildings/watch_tower_64.png';
    case CITY_PROPERTIES.FAITH:
      return 'images/city_buildings/watch_tower_64.png';
    case CITY_PROPERTIES.GLORY:
      return 'images/city_buildings/watch_tower_64.png';
    default: throw 'City property $prop is not recognized';
  }
}

String cityBuildingTypeToString(CITY_BUILDING_TYPES type) {
  switch (type) {
    case CITY_BUILDING_TYPES.WATCH_TOWER:
      return 'Watch Tower';
    case CITY_BUILDING_TYPES.TOWER:
      return 'Tower';
    case CITY_BUILDING_TYPES.HOUSE:
      return 'House';
    case CITY_BUILDING_TYPES.CHURCH:
      return 'Church';
    case CITY_BUILDING_TYPES.WALL:
      return 'Wall';
    default: throw 'City building $type is not recognized';
  }
}

String cityTypeToIconPath(CITY_BUILDING_TYPES type) {
  switch (type) {
    case CITY_BUILDING_TYPES.WATCH_TOWER:
      return 'images/city_buildings/watch_tower_64.png';
    case CITY_BUILDING_TYPES.TOWER:
      return 'images/city_buildings/kurin_64.png';
    case CITY_BUILDING_TYPES.HOUSE:
      return 'images/city_buildings/kurin_64.png';
    case CITY_BUILDING_TYPES.WALL:
      return 'images/city_buildings/wall_64.png';
    case CITY_BUILDING_TYPES.CHURCH:
      return 'images/city_buildings/kurin_64.png';
    default: throw 'City $type is not recognized';
  }
}

String cityTypeToImagePath(CITY_BUILDING_TYPES type) {
  switch (type) {
    case CITY_BUILDING_TYPES.WATCH_TOWER:
      return 'images/city_buildings/watch_tower.png';
    case CITY_BUILDING_TYPES.TOWER:
      return 'images/city_buildings/kurin.png';
    case CITY_BUILDING_TYPES.HOUSE:
      return 'images/city_buildings/kurin.png';
    case CITY_BUILDING_TYPES.WALL:
      return 'images/city_buildings/wall.png';
    case CITY_BUILDING_TYPES.CHURCH:
      return 'images/city_buildings/kurin.png';
    default: throw 'Building $type is not recognized';
  }
}

