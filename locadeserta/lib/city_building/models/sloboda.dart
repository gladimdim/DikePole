import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';

class Sloboda {
  int foundedYear = 1550;
  List<CityBuilding> cityBuildings = [
    CityBuilding.fromType(CITY_BUILDING_TYPES.HOUSE),
  ];

  Map<CITY_PROPERTIES, int> properties = {
    CITY_PROPERTIES.GLORY: 1,
    CITY_PROPERTIES.DEFENSE: 1,
    CITY_PROPERTIES.CITIZENS: 15,
  };
  List<ResourceBuilding> resourceBuildings = [];
  String name;

  Sloboda({this.name});

  Map<RESOURCE_TYPES, int> stock = {
    RESOURCE_TYPES.FOOD: 50,
    RESOURCE_TYPES.FIREARM: 5,
    RESOURCE_TYPES.WOOD: 50,
    RESOURCE_TYPES.STONE: 30,
  };
}
