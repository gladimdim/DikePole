import 'package:sloboda/models/abstract/stock_item.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';

class Wall extends CityBuilding {
  CITY_BUILDING_TYPES type = CITY_BUILDING_TYPES.WALL;
  StockItem<CITY_PROPERTIES> produces = CityDefense();

  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 20,
    RESOURCE_TYPES.WOOD: 100,
  };
}
