import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class IronMine extends ResourceBuilding {
  String localizedKey = 'resourceBuildings.ironMine';
  String localizedDescriptionKey = 'resourceBuildings.ironMineDescription';
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.IRON_MINE;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 10,
    RESOURCE_TYPES.WOOD: 15,
  };

  String toIconPath() {
    return 'images/resource_buildings/iron_mine_64.png';
  }

  String toImagePath() {
    return 'images/resource_buildings/iron_mine.png';
  }

  int workMultiplier = 3;

  ResourceType produces = IronOre();

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 5,
  };
}
