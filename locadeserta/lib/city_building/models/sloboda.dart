import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';

class Sloboda {
  String name;
  int foundedYear = 1550;
  List<CityBuilding> cityBuildings = [
    CityBuilding.fromType(CITY_BUILDING_TYPES.HOUSE),
  ];
  List<Citizen> citizens = [];
  Map<CITY_PROPERTIES, int> properties = {
    CITY_PROPERTIES.GLORY: 1,
    CITY_PROPERTIES.DEFENSE: 1,
    CITY_PROPERTIES.CITIZENS: 15,
  };

  List<ResourceBuilding> resourceBuildings = [];

  Sloboda({this.name}) {
    for (var i = 0; i < properties[CITY_PROPERTIES.CITIZENS]; i++) {
      citizens.add(Citizen());
    }
  }

  Map<RESOURCE_TYPES, int> stock = {
    RESOURCE_TYPES.FOOD: 50,
    RESOURCE_TYPES.FIREARM: 5,
    RESOURCE_TYPES.WOOD: 50,
    RESOURCE_TYPES.STONE: 30,
    RESOURCE_TYPES.IRON: 10,
    RESOURCE_TYPES.MONEY: 50,
    RESOURCE_TYPES.HORSE: 10,
    RESOURCE_TYPES.SULFUR: 20,
    RESOURCE_TYPES.FUR: 0,
    RESOURCE_TYPES.FISH: 0,
  };

  bool hasFreeCitizens() {
    return citizens.where((citizen) => !citizen.occupied()).length > 0;
  }

  Citizen getFirstFreeCitizen() {
    var free = citizens.where((citizen) => !citizen.occupied()).toList();
    if (free.isEmpty) {
      throw 'No free citizens';
    } else {
      return free[0];
    }
  }

  List<Citizen> getAllFreeCitizens() {
    return citizens.where((citizen) => !citizen.occupied()).toList();
  }

  void removeResourceBuildingByType(BUILDING_TYPES type) {
    var building = resourceBuildings.lastWhere((b) => b.type == type);

    building.removeWorker();

    resourceBuildings.remove(building);
  }

  void makeTurn() {
    var exceptions = [];
    resourceBuildings.forEach((resBuilding) {
      try {
        resBuilding.generate(stock);
      } catch (e) {
        exceptions.add(e);
      }
    });

    if (exceptions.isNotEmpty) {
      throw exceptions;
    }
  }
}
