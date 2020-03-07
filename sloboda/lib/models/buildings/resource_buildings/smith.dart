import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class Smith extends ResourceBuilding {
  String localizedKey = 'resourceBuildings.smith';
  String localizedDescriptionKey = 'resourceBuildings.smithDescription';
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.SMITH;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.WOOD: 3,
    RESOURCE_TYPES.STONE: 3,
  };

  String toIconPath() {
    return 'images/resource_buildings/smith_64.png';
  }

  String toImagePath() {
    return 'images/resource_buildings/smith.png';
  }

  ResourceType produces = FireArm();

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 2,
    RESOURCE_TYPES.IRON_ORE: 1,
    RESOURCE_TYPES.POWDER: 1,
  };
}
