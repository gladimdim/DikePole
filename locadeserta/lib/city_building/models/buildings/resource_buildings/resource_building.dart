import 'package:locadeserta/city_building/models/buildings/resource_buildings/field.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/mill.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/quarry.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/smith.dart';
import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

abstract class ResourceBuilding {
  static Map<RESOURCE_TYPES, int> requiredToBuild;

  BUILDING_TYPES type;
  int workMultiplier = 1;
  Map<RESOURCE_TYPES, int> requires = Map();
  RESOURCE_TYPES produces;
  List<Citizen> _assignedHumans = [];

  int output() {
    return workMultiplier * _assignedHumans.length;
  }

  static ResourceBuilding fromType(BUILDING_TYPES type) {
    switch (type) {
      case BUILDING_TYPES.FIELD:
        return Field();
      case BUILDING_TYPES.MILL:
        return Mill();
      case BUILDING_TYPES.QUARRY:
        return Quarry();
      case BUILDING_TYPES.SMITH:
        return Smith();
    }
  }

  void addWorker(Citizen citizen) {
    if (citizen.occupied()) {
      return;
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

  void generate(Map<RESOURCE_TYPES, int> stock) {
    if (!hasWorkers()) {
      throw NoWorkersAssignedException(
          'Building $type has no workers assigned');
    }

    if (requires.entries.length > 0) {
      var executors = [];
      // check if stock satisfies the required input
      for (var reqRes in requires.entries) {
        var inStock = stock[reqRes.key];
        var requiredToProduce = reqRes.value * _assignedHumans.length;
        if (requiredToProduce > inStock) {
          throw NotEnoughResourceException(
              'There is no enough ${reqRes.key} in stock');
        } else {
          executors.add(() {
            stock[reqRes.key] = stock[reqRes.key] - requiredToProduce;
          });
        }
      }

      // no exception was thrown, we can execute the stock
      executors.forEach((executor) => executor());
    }
    stock[produces] = stock[produces] + _assignedHumans.length * workMultiplier;
  }
}

enum BUILDING_TYPES { SMITH, FIELD, MILL, QUARRY }

buildingTypeToString(BUILDING_TYPES type) {
  switch (type) {
    case BUILDING_TYPES.FIELD: return 'Field';
    case BUILDING_TYPES.MILL: return 'Mill';
    case BUILDING_TYPES.SMITH: return 'Smith';
    case BUILDING_TYPES.QUARRY: return 'Quarry';
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
