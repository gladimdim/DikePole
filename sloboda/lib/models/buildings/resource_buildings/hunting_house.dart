import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class TrapperHouse extends ResourceBuilding {
  String localizedKey = 'resourceBuildings.trapperCabin';
  String localizedDescriptionKey = 'resourceBuildings.trapperCabinDescription';
  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 3,
    RESOURCE_TYPES.WOOD: 15,
  };

  String toIconPath() {
    return 'images/resource_buildings/trappershouse_64.png';
  }

  String toImagePath() {
    return 'images/resource_buildings/trappershouse.png';
  }

  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 5,
  };
  int maxWorkers = 1;
  int workMultiplier = 2;

  ResourceType produces = Fur();
}
