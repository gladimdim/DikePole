import 'package:locadeserta/city_building/models/buildings/resource_buildings/field.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/mill.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/quarry.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/smith.dart';
import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

abstract class ResourceBuilding {
  static Map<RESOURCE_TYPES, int> requiredToBuild;

  BUILDING_TYPES type;
  int stock = 0;
  int workMultiplier = 1;
  Map<RESOURCE_TYPES, int> input = Map();
  List<RESOURCE_TYPES> requires = [];
  RESOURCE_TYPES produces;
  List<Citizen> _assignedHumans = [];

  static fromType(BUILDING_TYPES type) {
    switch (type) {
      case BUILDING_TYPES.FIELD: return Field();
      case BUILDING_TYPES.MILL: return Mill();
      case BUILDING_TYPES.QUARRY: return Quarry();
      case BUILDING_TYPES.SMITH: return Smith();
    }
  }
  void addWorker(Citizen citizen) {
    _assignedHumans.add(citizen);
  }

  Citizen removeWorker() {
    return _assignedHumans.removeLast();
  }

  bool hasWorkers() {
    return _assignedHumans.isNotEmpty;
  }

  void generate() {
    if (!hasWorkers()) {
      throw NoWorkersAssignedException(
          'Building $type has no workers assigned');
    }
    for (var r in requires) {
      if (input[r] > 0) {
        continue;
      } else {
        throw NotEnoughResourceException('Building $type has not enough: $r');
      }
    }

    stock = stock + workMultiplier * _assignedHumans.length;

    input.keys.forEach((key) {
      input[key] = input[key] - 1;
    });
  }
}

enum BUILDING_TYPES { SMITH, FIELD, MILL, QUARRY }

class NotEnoughResourceException implements Exception {
  String cause;

  NotEnoughResourceException(this.cause);
}

class NoWorkersAssignedException implements Exception {
  String cause;
  NoWorkersAssignedException(this.cause);
}
