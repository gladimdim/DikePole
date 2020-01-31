import 'package:rxdart/rxdart.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/stock.dart';

class Producable {
  BehaviorSubject changes = BehaviorSubject();
  RESOURCE_TYPES produces;
  Map<RESOURCE_TYPES, int> requires = Map();
  List<Citizen> assignedHumans = [];
  int maxWorkers = 5;
  int workMultiplier = 1;

  get outputAmount =>
     workMultiplier * assignedHumans.length;

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
    if (citizen.occupied) {
      return;
    }

    if (maxWorkers < assignedHumans.length + 1) {
      throw BuildingFull('Building is at maximum capacity: $maxWorkers');
    }
    assignedHumans.add(citizen);
    citizen.assignedTo = this;

    changes.add(this);
  }

  Citizen removeWorker(Citizen h) {
    assignedHumans.remove(h);
    if (h != null) {
      h.free();
    }

    changes.add(this);

    return h;
  }

  void generate(Stock stock) {
    if (!hasWorkers()) {
      throw NoWorkersAssignedException('${toString()} has no assigned workers.');
    }

    if (requires.entries.length > 0) {
      var executors = [];
      // check if stock satisfies the required input
      for (var reqRes in requires.entries) {
        var inStock = stock.getByType(reqRes.key) ?? 0;
        var requiredToProduce = reqRes.value * assignedHumans.length * workMultiplier;
        if (requiredToProduce > inStock) {
          throw NotEnoughResourceException(
              '${this.toString()}: More qty ${requiredToProduce - inStock} of ${resourceTypesToString(reqRes.key)} is required');
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

  void destroy() {
    assignedHumans.forEach((citizen) => citizen.free());
    changes.close();
  }

  String toString() {
    throw 'Must Implement';
  }
}