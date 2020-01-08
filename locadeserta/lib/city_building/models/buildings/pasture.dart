import 'package:locadeserta/city_building/models/buildings/building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class Pasture extends Building {
  static Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 1,
  };
  RESOURCE_TYPES produces = RESOURCE_TYPES.HORSE;
}