import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/buildings/resource_buildings/field.dart';
import 'package:sloboda/models/buildings/resource_buildings/hunting_house.dart';
import 'package:sloboda/models/buildings/resource_buildings/iron_mine.dart';
import 'package:sloboda/models/buildings/resource_buildings/mill.dart';
import 'package:sloboda/models/buildings/resource_buildings/powder_cellar.dart';
import 'package:sloboda/models/buildings/resource_buildings/quarry.dart';
import 'package:sloboda/models/buildings/resource_buildings/smith.dart';
import 'package:sloboda/models/buildings/resource_buildings/stables.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda_localizations.dart';

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
      case RESOURCE_BUILDING_TYPES.POWDER_CELLAR:
        return PowderCellar();
      default: throw 'Resource Type not Recognized';
    }
  }

  String toLocalizedString() {
    return localizedBuildingTypeName(type);
  }

}

enum RESOURCE_BUILDING_TYPES { SMITH, FIELD, MILL, QUARRY, STABLES, IRON_MINE, TRAPPER_HOUSE, POWDER_CELLAR }

String buildingTypeToKey (RESOURCE_BUILDING_TYPES type) {
  switch (type) {
    case RESOURCE_BUILDING_TYPES.FIELD: return 'resourceBuildings.field';
    case RESOURCE_BUILDING_TYPES.MILL:  return 'resourceBuildings.mill';
    case RESOURCE_BUILDING_TYPES.SMITH:  return 'resourceBuildings.smith';
    case RESOURCE_BUILDING_TYPES.QUARRY: return 'resourceBuildings.quarry';
    case RESOURCE_BUILDING_TYPES.STABLES: return 'resourceBuildings.stables';
    case RESOURCE_BUILDING_TYPES.IRON_MINE: return 'resourceBuildings.ironMine';
    case RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE: return'resourceBuildings.trapperCabin';
    case RESOURCE_BUILDING_TYPES.POWDER_CELLAR: return'resourceBuildings.powderCellar';
    default: throw 'Building $type is not recognized';
  }
}

String localizedBuildingTypeName(RESOURCE_BUILDING_TYPES type) {
  return SlobodaLocalizations.getForKey(buildingTypeToKey(type));
}

String buildingTypeToIconPath(RESOURCE_BUILDING_TYPES type) {
  switch (type) {
    case RESOURCE_BUILDING_TYPES.FIELD: return 'images/resource_buildings/field_64.png';
    case RESOURCE_BUILDING_TYPES.MILL: return 'images/resource_buildings/mill_64.png';
    case RESOURCE_BUILDING_TYPES.SMITH: return 'images/resource_buildings/mill_64.png';
    case RESOURCE_BUILDING_TYPES.QUARRY: return 'images/resource_buildings/quarry_64.png';
    case RESOURCE_BUILDING_TYPES.STABLES: return 'images/resource_buildings/stable_64.png';
    case RESOURCE_BUILDING_TYPES.IRON_MINE: return 'images/resource_buildings/iron_mine_64.png';
    case RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE: return 'images/resource_buildings/trappershouse_64.png';
    case RESOURCE_BUILDING_TYPES.POWDER_CELLAR: return 'images/resource_buildings/powder_cellar_64.png';
    default: throw 'Building $type is not recognized';
  }
}

String buildingTypeToImagePath(RESOURCE_BUILDING_TYPES type) {
  switch (type) {
    case RESOURCE_BUILDING_TYPES.FIELD: return 'images/resource_buildings/field.png';
    case RESOURCE_BUILDING_TYPES.MILL: return 'images/resource_buildings/mill.png';
    case RESOURCE_BUILDING_TYPES.SMITH: return 'images/resource_buildings/mill.png';
    case RESOURCE_BUILDING_TYPES.QUARRY: return 'images/resource_buildings/quarry.png';
    case RESOURCE_BUILDING_TYPES.STABLES: return 'images/resource_buildings/stable.png';
    case RESOURCE_BUILDING_TYPES.IRON_MINE: return 'images/resource_buildings/iron_mine.png';
    case RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE: return 'images/resource_buildings/trappershouse.png';
    case RESOURCE_BUILDING_TYPES.POWDER_CELLAR: return 'images/resource_buildings/powder_cellar.png';
    default: throw 'Building $type is not recognized';
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
    case RESOURCE_BUILDING_TYPES.POWDER_CELLAR: return 'Produces Gun Powder. Used for makeing guns.';

    default: throw 'Building $type is not recognized';
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
