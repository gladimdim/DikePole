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

abstract class ResourceBuilding
    with Producable
    implements Buildable<RESOURCE_TYPES> {
  Map<RESOURCE_TYPES, int> requiredToBuild;

  RESOURCE_BUILDING_TYPES type;
  int workMultiplier = 1;
  Map<RESOURCE_TYPES, int> requires = Map();
  String localizedKey;
  String localizedDescriptionKey;

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
      default:
        throw 'Resource Type not Recognized';
    }
  }

  String toLocalizedString() {
    return SlobodaLocalizations.getForKey(localizedKey);
  }

  String toLocalizedDescriptionString() {
    return SlobodaLocalizations.getForKey(localizedDescriptionKey);
  }

  String toIconPath();

  String toImagePath();
}

enum RESOURCE_BUILDING_TYPES {
  SMITH,
  FIELD,
  MILL,
  QUARRY,
  STABLES,
  IRON_MINE,
  TRAPPER_HOUSE,
  POWDER_CELLAR
}

class BuildingFull implements Exception {
  String cause;

  BuildingFull(this.cause);
}
