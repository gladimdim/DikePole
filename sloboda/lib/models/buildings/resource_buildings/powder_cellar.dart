import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class PowderCellar extends ResourceBuilding {
  String localizedKey = 'resourceBuildings.powderCellar';
  String localizedDescriptionKey = 'resourceBuildings.powderCellarDescription';
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.POWDER_CELLAR;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 5,
    RESOURCE_TYPES.WOOD: 5,
    RESOURCE_TYPES.STONE: 2,
  };

  String toIconPath() {
    return 'images/resource_buildings/powder_cellar_64.png';
  }

  String toImagePath() {
    return 'images/resource_buildings/powder_cellar.png';
  }

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 3,
  };

  int workMultiplier = 2;

  int maxWorkers = 3;

  ResourceType produces = Powder();
}
