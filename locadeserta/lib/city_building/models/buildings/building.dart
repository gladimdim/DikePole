import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class Building {
  static Map<RESOURCE_TYPES, int> requiredToBuild;

  BUILDING_TYPES type;
  int stock = 0;
  Map<RESOURCE_TYPES, int> input = Map();
  List<RESOURCE_TYPES> requires = [];
  RESOURCE_TYPES produces;
  List<Citizen> _assignedHumans = [];

  Building({this.type});
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

    stock++;

    input.keys.forEach((key) {
      input[key] = input[key] - 1;
    });
  }
}

enum BUILDING_TYPES { SMITH, PASTURE, HOUSE, FIELD, MILL, FOREST }

class NotEnoughResourceException implements Exception {
  String cause;

  NotEnoughResourceException(this.cause);
}

class NoWorkersAssignedException implements Exception {
  String cause;
  NoWorkersAssignedException(this.cause);
}
