import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/buildings/resource_buildings/field.dart';
import 'package:sloboda/models/buildings/resource_buildings/hunting_house.dart';
import 'package:sloboda/models/buildings/resource_buildings/iron_mine.dart';
import 'package:sloboda/models/buildings/resource_buildings/mill.dart';
import 'package:sloboda/models/buildings/resource_buildings/quarry.dart';
import 'package:sloboda/models/buildings/resource_buildings/smith.dart';
import 'package:sloboda/models/buildings/resource_buildings/stables.dart';
import 'package:sloboda/models/resources/resource.dart';

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
    case RESOURCE_BUILDING_TYPES.FIELD: return 'images/resource_buildings/field_64.png';
    case RESOURCE_BUILDING_TYPES.MILL: return 'images/resource_buildings/kurin_64.png';
    case RESOURCE_BUILDING_TYPES.SMITH: return 'images/resource_buildings/kurin_64.png';
    case RESOURCE_BUILDING_TYPES.QUARRY: return 'images/resource_buildings/quarry_64.png';
    case RESOURCE_BUILDING_TYPES.STABLES: return 'images/resource_buildings/stable_64.png';
    case RESOURCE_BUILDING_TYPES.IRON_MINE: return 'images/resource_buildings/iron_mine_64.png';
    case RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE: return 'images/resource_buildings/trappershouse_64.png';
  }
}

String buildingTypeToImagePath(RESOURCE_BUILDING_TYPES type) {
  switch (type) {
    case RESOURCE_BUILDING_TYPES.FIELD: return 'images/resource_buildings/field.png';
    case RESOURCE_BUILDING_TYPES.MILL: return 'images/resource_buildings/kurin.png';
    case RESOURCE_BUILDING_TYPES.SMITH: return 'images/resource_buildings/kurin.png';
    case RESOURCE_BUILDING_TYPES.QUARRY: return 'images/resource_buildings/quarry.png';
    case RESOURCE_BUILDING_TYPES.STABLES: return 'images/resource_buildings/stable.png';
    case RESOURCE_BUILDING_TYPES.IRON_MINE: return 'images/resource_buildings/iron_mine.png';
    case RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE: return 'images/resource_buildings/trappershouse.png';
  }
}

String getDescriptionForResourceBuildingType(RESOURCE_BUILDING_TYPES type) {
  switch (type) {
    case RESOURCE_BUILDING_TYPES.FIELD: return 'Assign cossacks to produce Food.';
    case RESOURCE_BUILDING_TYPES.MILL: return 'Worker consumes food to produce gold.';
    case RESOURCE_BUILDING_TYPES.SMITH: return 'Worker consumes food, gunpowder and iron to produce firearms.';
    case RESOURCE_BUILDING_TYPES.QUARRY: return 'Worker consumes food to produce stone. Required for city buildings';
    case RESOURCE_BUILDING_TYPES.STABLES: return 'Worker consumes food to produce Horses. If you want to raid other lands, you must get some horses.';
    case RESOURCE_BUILDING_TYPES.IRON_MINE: return 'Worker consumes food to produce iron. Iron is used to produce firearms. If you want to fight, create few iron mines.';
    case RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE: return 'Hunts animals. Skins them for Fur. Fur can be sold for money at marketplaces.';
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
