import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class Mill extends ResourceBuilding {
  String localizedKey = 'resourceBuildings.mill';
  String localizedDescriptionKey = 'resourceBuildings.millDescription';
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.MILL;

  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 5,
    RESOURCE_TYPES.STONE: 5,
    RESOURCE_TYPES.WOOD: 5,
  };

  String toIconPath() {
    return 'images/resource_buildings/mill_64.png';
  }

  String toImagePath() {
    return 'images/resource_buildings/mill.png';
  }

  int workMultiplier = 2;

  ResourceType produces = Money();

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 5,
  };
}
