import 'package:locadeserta/city_building/models/abstract/buildable.dart';
import 'package:locadeserta/city_building/models/abstract/producable.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/field.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/hunting_house.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/iron_mine.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/mill.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/quarry.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/smith.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/stables.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

abstract class ResourceBuilding with Producable implements Buildable<RESOURCE_TYPES> {
  Map<RESOURCE_TYPES, int> requiredToBuild;

  RESOURCE_BUILDING_TYPES type;
  int workMultiplier = 1;
  Map<RESOURCE_TYPES, int> requires = Map();

  static ResourceBuilding fromType(RESOURCE_BUILDING_TYPES type) {
    switch (type) {
      case RESOURCE_BUILDING_TYPES.FIELD:
        return Field();
      case RESOURCE_BUILDING_TYPES.MILL:
        return Mill();
      case RESOURCE_BUILDING_TYPES.QUARRY:
        return Quarry();
      case RESOURCE_BUILDING_TYPES.SMITH:
        return Smith();
      case RESOURCE_BUILDING_TYPES.STABLES:
        return Stables();
      case RESOURCE_BUILDING_TYPES.IRON_MINE:
        return IronMine();
      case RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE:
        return TrapperHouse();
    }
  }

  void destroy() {
    assignedHumans.forEach((citizen) => citizen.free());
  }

}

enum RESOURCE_BUILDING_TYPES { SMITH, FIELD, MILL, QUARRY, STABLES, IRON_MINE, TRAPPER_HOUSE }

String buildingTypeToString(RESOURCE_BUILDING_TYPES type) {
  switch (type) {
    case RESOURCE_BUILDING_TYPES.FIELD: return 'Field';
    case RESOURCE_BUILDING_TYPES.MILL: return 'Mill';
    case RESOURCE_BUILDING_TYPES.SMITH: return 'Smith';
    case RESOURCE_BUILDING_TYPES.QUARRY: return 'Quarry';
    case RESOURCE_BUILDING_TYPES.STABLES: return 'Stables';
    case RESOURCE_BUILDING_TYPES.IRON_MINE: return 'Iron mine';
    case RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE: return 'Trapper\'s Cabin';
  }
}

String buildingTypeToIconPath(RESOURCE_BUILDING_TYPES type) {
  switch (type) {
    case RESOURCE_BUILDING_TYPES.FIELD: return 'images/city_building/resource_buildings/field.png';
    case RESOURCE_BUILDING_TYPES.MILL: return 'images/city_building/resource_buildings/kurin.png';
    case RESOURCE_BUILDING_TYPES.SMITH: return 'images/city_building/resource_buildings/kurin.png';
    case RESOURCE_BUILDING_TYPES.QUARRY: return 'images/city_building/resource_buildings/quarry.png';
    case RESOURCE_BUILDING_TYPES.STABLES: return 'images/city_building/resource_buildings/stable.png';
    case RESOURCE_BUILDING_TYPES.IRON_MINE: return 'images/city_building/resource_buildings/iron_mine.png';
    case RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE: return 'images/city_building/resource_buildings/trappershouse.png';
  }
}

class NotEnoughResourceException implements Exception {
  String cause;

  NotEnoughResourceException(this.cause);
}

class NoWorkersAssignedException implements Exception {
  String cause;

  NoWorkersAssignedException(this.cause);
}

class BuildingFull implements Exception {
  String cause;

  BuildingFull(this.cause);
}
