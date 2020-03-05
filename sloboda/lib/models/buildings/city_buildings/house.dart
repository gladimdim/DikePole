import 'package:sloboda/models/abstract/stock_item.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';

class House extends CityBuilding {
  CITY_BUILDING_TYPES type = CITY_BUILDING_TYPES.HOUSE;
  StockItem<CITY_PROPERTIES> produces = CityCitizens();
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 10,
    RESOURCE_TYPES.STONE: 3,
    RESOURCE_TYPES.WOOD: 10,
  };
}
