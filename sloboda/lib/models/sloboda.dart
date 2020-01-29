import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/buildings/resource_buildings/nature_resource.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/stock.dart';
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

    for (var nr in naturalResources) {
      nr.changes.stream.listen(_buildingChangesListener);
    }

    for (var rb in resourceBuildings) {
      rb.changes.stream.listen(_buildingChangesListener);
    }
  }

  _buildingChangesListener(event) {
    _innerChanges.add(this);
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

  void removeResourceBuilding(ResourceBuilding building) {
    resourceBuildings.remove(building);
    building.destroy();
    _innerChanges.add(this);
  }

  void removeCityBuilding(CityBuilding building) {
    cityBuildings.remove(building);
    _innerChanges.add(this);
  }

  void makeTurn() {
    var exceptions = [];
    simulateStock();
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

    cityBuildings.forEach((cb) {
      Map<CITY_PROPERTIES, int> generated = cb.generate();
      generated.entries.forEach((e) {
        if (e.key == CITY_PROPERTIES.CITIZENS) {
          citizens.add(Citizen());
        }
        properties[e.key] += e.value;
      });
    });
  }

  Map<CITY_PROPERTIES, int> simulateCityProps() {
    Map<CITY_PROPERTIES, int> newMap =
        cityBuildings.fold(Map.from(properties), (Map value, cb) {
      var prod = cb.produces;
      if (value.containsKey(prod)) {
        value[prod] += cb.outputAmount;
      } else {
        value[prod] = properties[prod];
      }
      return value;
    });

    return newMap;
  }

  Map<RESOURCE_TYPES, int> simulateStock() {
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

    Map<RESOURCE_TYPES, int> newStock = Map();
    RESOURCE_TYPES.values.forEach((type) {
      if (!newStock.containsKey(type)) {
        newStock[type] = 0;
      }
      if (!produces.containsKey(type)) {
        produces[type] = 0;
      }
      if (!requires.containsKey(type)) {
        requires[type] = 0;
      }
      try {
        newStock[type] =
            produces[type] - requires[type] + stock.getByType(type);
      } catch (e) {
        print(e);
      }
    });

    return newStock;
  }

  void dispose() {
    _innerChanges.close();
  }
}
