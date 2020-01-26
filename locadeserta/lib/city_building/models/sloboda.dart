import 'package:locadeserta/city_building/models/abstract/buildable.dart';
import 'package:locadeserta/city_building/models/abstract/producable.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/nature_resource.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
import 'package:locadeserta/city_building/models/stock.dart';
import 'package:rxdart/rxdart.dart';

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
    CITY_PROPERTIES.FAITH: 1,
  };

  List<ResourceBuilding> resourceBuildings = [];
  List<NaturalResource> naturalResources = [
    Forest(),
    River(),
  ];

  final Stock stock = Stock();

  BehaviorSubject _innerChanges = BehaviorSubject();
  ValueStream changes;

  Sloboda({this.name}) {
    for (var i = 0; i < properties[CITY_PROPERTIES.CITIZENS]; i++) {
      citizens.add(Citizen());
    }
    changes = _innerChanges.stream;
  }

  bool hasFreeCitizens() {
    return citizens.where((citizen) => !citizen.occupied()).length > 0;
  }

  _removeFromStock(Map<RESOURCE_TYPES, int> map) {
    map.entries.forEach((e) {
      stock.removeFromType(e.key, e.value);
    });

    _innerChanges.add(this);
  }

  buildBuilding(Buildable buildable) {
    if (canBuildResourceBuilding(buildable)) {
      _removeFromStock(buildable.requiredToBuild);
      if (buildable is ResourceBuilding) {
        resourceBuildings.add(buildable);
      } else if (buildable is CityBuilding) {
        cityBuildings.add(buildable);
      }
      _innerChanges.add(this);
    }
  }

  bool canBuildResourceBuilding(Buildable b) {
    var required = b.requiredToBuild;
    var missing = [];
    required.entries.forEach((r) {
      if (r.value > stock.getByType(r.key)) {
        missing.add({r.key: r.value - stock.getByType(r.key)});
      }
    });

    if (missing.isEmpty) {
      return true;
    } else {
      throw missing;
    }
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

  void removeResourceBuildingByType(RESOURCE_BUILDING_TYPES type) {
    var building = resourceBuildings.lastWhere((b) => b.type == type);
    building.removeWorker();
    resourceBuildings.remove(building);
    _innerChanges.add(this);
  }

  void removeResourceBuilding(ResourceBuilding building) {
    resourceBuildings.remove(building);
    building.destroy();
    _innerChanges.add(this);
  }

  void makeTurn() {
    var exceptions = [];
    simulate();
    List<Producable> list = [...naturalResources, ...resourceBuildings];

    list.forEach((resBuilding) {
      try {
        resBuilding.generate(stock);
      } catch (e) {
        exceptions.add(e);
      }
    });

    _innerChanges.add(this);
    if (exceptions.isNotEmpty) {
      print(exceptions);
    }
  }

  Map<RESOURCE_TYPES, int> simulate() {
    List<Producable> list = [...naturalResources, ...resourceBuildings];

    Map requires = list.fold({}, (Map value, building) {
      var req = building.requires.map((k, v) {
        return MapEntry(
            k, v * building.amountOfWorkers() * building.workMultiplier);
      });

      req.entries.forEach((element) {
        if (value.containsKey(element.key)) {
          value[element.key] += element.value;
        } else {
          value[element.key] = element.value;
        }
      });
      return value;
    });

    Map produces = list.fold({}, (Map value, building) {
      if (value.containsKey(building.produces)) {
        value[building.produces] +=
            building.workMultiplier * building.amountOfWorkers();
      } else {
        value[building.produces] =
            building.workMultiplier * building.amountOfWorkers();
      }

      return value;
    });

    Map<RESOURCE_TYPES, int> diff = Map();
    RESOURCE_TYPES.values.forEach((type) {
      if (!diff.containsKey(type)) {
        diff[type] = 0;
      }
      if (!produces.containsKey(type)) {
        produces[type] = 0;
      }
      if (!requires.containsKey(type)) {
        requires[type] = 0;
      }
      try {
        diff[type] = produces[type] - requires[type];
      } catch (e) {
        print(e);
      }
    });

    return diff;
  }

  void dispose() {
    _innerChanges.close();
  }
}
