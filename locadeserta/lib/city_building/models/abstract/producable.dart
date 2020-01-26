import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/stock.dart';

class Producable {
  RESOURCE_TYPES produces;
  Map<RESOURCE_TYPES, int> requires = Map();
  List<Citizen> assignedHumans = [];
  int maxWorkers = 5;
  int workMultiplier = 1;

  int output() {
    return workMultiplier * assignedHumans.length;
  }

  bool hasWorkers() {
    return assignedHumans.isNotEmpty;
  }

  int amountOfWorkers() {
    return assignedHumans.length;
  }

  bool isFull() {
    return maxWorkers == assignedHumans.length;
  }

  bool isEmpty() {
    return assignedHumans.length == 0;
  }

  void addWorker(Citizen citizen) {
    if (citizen.occupied()) {
      return;
    }

    if (maxWorkers < assignedHumans.length + 1) {
      throw BuildingFull('Building is at maximum capacity: $maxWorkers');
    }
    assignedHumans.add(citizen);
    citizen.assignedTo = this;
  }

  Citizen removeWorker() {
    var freed = assignedHumans.isNotEmpty ? assignedHumans.removeLast() : null;
    if (freed != null) {
      freed.free();
    }

    return freed;
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
        var requiredToProduce = reqRes.value * assignedHumans.length * workMultiplier;
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
    stock.addToType(produces, assignedHumans.length * workMultiplier);
  }
}