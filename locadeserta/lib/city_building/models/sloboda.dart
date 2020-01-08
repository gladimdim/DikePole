import 'package:locadeserta/city_building/models/buildings/building.dart';
import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class Sloboda {
  int foundedYear = 1550;
  List<Citizen> citizens = [];
  List<Building> buildings = [
    Building(type: BUILDING_TYPES.FOREST),
    Building(type: BUILDING_TYPES.PASTURE),
    Building(type: BUILDING_TYPES.HOUSE),
  ];
  String name;

  Sloboda({this.name}) {
    for (var i = 0; i < 15; i++) {
      citizens.add(Citizen());
    }
  }

  Map<RESOURCE_TYPES, int> stock = {
    RESOURCE_TYPES.FOOD: 50,
    RESOURCE_TYPES.FIREARM: 5,
    RESOURCE_TYPES.WOOD: 50,
    RESOURCE_TYPES.STONE: 30,
  };
}
