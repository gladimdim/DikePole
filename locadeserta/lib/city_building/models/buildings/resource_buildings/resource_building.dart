import 'package:locadeserta/city_building/models/buildings/resource_buildings/field.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/iron_mine.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/mill.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/quarry.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/smith.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/stables.dart';
import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/stock.dart';

abstract class ResourceBuilding {
  Map<RESOURCE_TYPES, int> requiredToBuild;

  RESOURCE_BUILDING_TYPES type;
  int workMultiplier = 1;
  Map<RESOURCE_TYPES, int> requires = Map();
  RESOURCE_TYPES produces;
  List<Citizen> _assignedHumans = [];
  int maxWorkers = 5;

  int output() {
    return workMultiplier * _assignedHumans.length;
  }

  static ResourceBuilding fromType(RESOURCE_BUILDING_TYPES type) {
    switch (type) {
      case RESOURCE_BUILDING_TYPES.FIELD:
        return Field();
      case RESOURCE_BUILDING_TYPES.MILL:
        return Mill();
      case RESOURCE_BUILDING_TYPES.QUARRY:
        return Quarry();
      case RESOURCE_BUILDING_TYPES.SMITH:
        return Smith();
      case RESOURCE_BUILDING_TYPES.STABLES:
        return Stables();
      case RESOURCE_BUILDING_TYPES.IRON_MINE:
        return IronMine();
    }
  }

  bool isFull() {
    return maxWorkers == _assignedHumans.length;
  }

  bool isEmpty() {
    return _assignedHumans.length == 0;
  }

  void destroy() {
    _assignedHumans.forEach((citizen) => citizen.free());
  }

  void addWorker(Citizen citizen) {
    if (citizen.occupied()) {
      return;
    }

    if (maxWorkers < _assignedHumans.length + 1) {
      throw BuildingFull('Building $type is at maximum capacity: $maxWorkers');
    }
    _assignedHumans.add(citizen);
    citizen.assignedTo = this;
  }

  Citizen removeWorker() {
     var freed = _assignedHumans.isNotEmpty ? _assignedHumans.removeLast() : null;
     if (freed != null) {
       freed.free();
     }

     return freed;
  }

  bool hasWorkers() {
    return _assignedHumans.isNotEmpty;
  }

  int amountOfWorkers() {
    return _assignedHumans.length;
  }

  void generate(Stock stock) {
    if (!hasWorkers()) {
      return;
    }

    if (requires.entries.length > 0) {
      var executors = [];
      // check if stock satisfies the required input
      for (var reqRes in requires.entries) {
        var inStock = stock.getByType(reqRes.key);
        var requiredToProduce = reqRes.value * _assignedHumans.length;
        if (requiredToProduce > inStock) {
          throw NotEnoughResourceException(
              'There is no enough ${reqRes.key} in stock');
        } else {
          executors.add(() {
            stock.removeFromType(reqRes.key, requiredToProduce);
          });
        }
      }

      // no exception was thrown, we can execute the stock
      executors.forEach((executor) => executor());
    }
    stock.addToType(produces, _assignedHumans.length * workMultiplier);
  }
}

enum RESOURCE_BUILDING_TYPES { SMITH, FIELD, MILL, QUARRY, STABLES, IRON_MINE }

String buildingTypeToString(RESOURCE_BUILDING_TYPES type) {
  switch (type) {
    case RESOURCE_BUILDING_TYPES.FIELD: return 'Field';
    case RESOURCE_BUILDING_TYPES.MILL: return 'Mill';
    case RESOURCE_BUILDING_TYPES.SMITH: return 'Smith';
    case RESOURCE_BUILDING_TYPES.QUARRY: return 'Quarry';
    case RESOURCE_BUILDING_TYPES.STABLES: return 'Stables';
    case RESOURCE_BUILDING_TYPES.IRON_MINE: return 'Iron mine';
  }
}

String buildingTypeToIconPath(RESOURCE_BUILDING_TYPES type) {
  switch (type) {
    case RESOURCE_BUILDING_TYPES.FIELD: return 'images/city_building/resource_buildings/field.png';
    case RESOURCE_BUILDING_TYPES.MILL: return 'images/city_building/resource_buildings/kurin.png';
    case RESOURCE_BUILDING_TYPES.SMITH: return 'images/city_building/resource_buildings/kurin.png';
    case RESOURCE_BUILDING_TYPES.QUARRY: return 'images/city_building/resource_buildings/quarry.png';
    case RESOURCE_BUILDING_TYPES.STABLES: return 'images/city_building/resource_buildings/kurin.png';
    case RESOURCE_BUILDING_TYPES.IRON_MINE: return 'images/city_building/resource_buildings/iron_mine.png';
  }
}

class NotEnoughResourceException implements Exception {
  String cause;

  NotEnoughResourceException(this.cause);
}

class NoWorkersAssignedException implements Exception {
  String cause;

  NoWorkersAssignedException(this.cause);
}

class BuildingFull implements Exception {
  String cause;

  BuildingFull(this.cause);
}
