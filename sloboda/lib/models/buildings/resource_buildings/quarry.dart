import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class Quarry extends ResourceBuilding {
  String localizedKey = 'resourceBuildings.quarry';
  String localizedDescriptionKey = 'resourceBuildings.quarryDescription';
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.QUARRY;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 5,
    RESOURCE_TYPES.WOOD: 5,
  };

  String toIconPath() {
    return 'images/resource_buildings/quarry_64.png';
  }

  String toImagePath() {
    return 'images/resource_buildings/quarry.png';
  }

  int workMultiplier = 3;

  ResourceType produces = Stone();

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 2,
  };
}
