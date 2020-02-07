import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/buildings/resource_buildings/nature_resource.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:rxdart/rxdart.dart';

class Sloboda {
  String name;
  int foundedYear = 1550;
  int currentYear = 1550;
  CITY_SEASONS currentSeason = CITY_SEASONS.SPRING;
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

  final List<CityEvent> events = [];

  Stock stock;

  BehaviorSubject _innerChanges = BehaviorSubject();
  ValueStream changes;

  Sloboda({this.name, this.stock}) {
    if (stock == null) {
      stock = Stock();
    }
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
    return citizens.where((citizen) => !citizen.occupied).length > 0;
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
        Producable producable = buildable;
        producable.changes.stream.listen(_buildingChangesListener);
      } else if (buildable is CityBuilding) {
        cityBuildings.add(buildable);
      }

      _innerChanges.add(this);
    }
  }

  bool canBuildResourceBuilding(Buildable b) {
    var required = b.requiredToBuild;
    Map<String, int> missing = {};
    required.entries.forEach((r) {
      if (r.value > stock.getByType(r.key)) {
        missing[resourceTypesToKey(r.key)] = r.value - stock.getByType(r.key);
      }
    });

    if (missing.isEmpty) {
      return true;
    } else {
      throw MissingResources(missing);
    }
  }

  Citizen getFirstFreeCitizen() {
    var free = citizens.where((citizen) => !citizen.occupied).toList();
    if (free.isEmpty) {
      throw 'No free citizens';
    } else {
      return free[0];
    }
  }

  List<Citizen> getAllFreeCitizens() {
    return citizens.where((citizen) => !citizen.occupied).toList();
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
        exceptions.add('${e.cause}');
      }
    });

    _innerChanges.add(this);
    events.add(
      CityEvent(
        messages: exceptions,
        yearHappened: currentYear,
        season: currentSeason,
      ),
    );

    cityBuildings.forEach((cb) {
      Map<CITY_PROPERTIES, int> generated = cb.generate();
      generated.entries.forEach((e) {
        if (e.key == CITY_PROPERTIES.CITIZENS) {
          citizens.add(Citizen());
        }
        properties[e.key] += e.value;
      });
    });

    _moveToNextSeason();
  }

  _moveToNextSeason() {
    currentSeason = nextSeason(currentSeason);
    if (currentSeason == CITY_SEASONS.WINTER) {
      currentYear++;
    }
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

  CITY_SEASONS nextSeason(CITY_SEASONS currentSeason) {
    switch (currentSeason) {
      case (CITY_SEASONS.SPRING):
        return CITY_SEASONS.SUMMER;
      case (CITY_SEASONS.SUMMER):
        return CITY_SEASONS.AUTUMN;
      case (CITY_SEASONS.AUTUMN):
        return CITY_SEASONS.WINTER;
      case (CITY_SEASONS.WINTER):
        return CITY_SEASONS.SPRING;
      default:
        return CITY_SEASONS.SPRING;
    }
  }

  void dispose() {
    _innerChanges.close();
  }
}

class MissingResources implements Exception {
  final Map<String, int> causes;

  MissingResources(this.causes);


  String toLocalizedString() {
    return causes.entries.map((c) {
      return '${SlobodaLocalizations.getForKey(c.key)}: ${c.value}';
    }).toList().toString();
  }
}