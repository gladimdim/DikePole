import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';

class Field extends ResourceBuilding {
  String localizedKey = 'resourceBuildings.field';
  String localizedDescriptionKey = 'resourceBuildings.fieldDescription';

  String toIconPath() {
    return 'images/resource_buildings/field_64.png';
  }

  String toImagePath() {
    return 'images/resource_buildings/field.png';
  }

  RESOURCE_BUILDING_TYPES type = RESOURCE_BUILDING_TYPES.FIELD;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 5,
  };

  int maxWorkers = 20;

  int workMultiplier = 5;

  ResourceType produces = Food();
}
