import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/stock.dart';
import 'package:test/test.dart';

void main() {
  group("Smith Main Tests", () {
    var smith = ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.SMITH);
    Stock stock = Stock(values: {
      RESOURCE_TYPES.FOOD: 5,
      RESOURCE_TYPES.FIREARM: 0,
      RESOURCE_TYPES.POWDER: 1,
      RESOURCE_TYPES.IRON_ORE: 1,
    });

    test("Does not require other resources", () {
      expect(smith.requires, isNotEmpty);
    });

    test("Can add worker", () {
      smith.addWorker(Citizen());
      expect(smith.hasWorkers(), isTrue);
    });

    test("Can tell if workers are assigned", () {
      expect(smith.hasWorkers(), isTrue);
    });

    test("Can generate firearm with 1 worker", () {
      smith.generate(stock);
      expect(stock.getByType(RESOURCE_TYPES.FIREARM), equals(1));
      expect(stock.getByType(RESOURCE_TYPES.FOOD), equals(3));
    });

    test("Can remove workers", () {
      var removedWorker = smith.assignedHumans[0];
      smith.removeWorker(removedWorker);
      expect(smith.assignedHumans.indexOf(removedWorker) < 0, true);
      expect(smith.hasWorkers(), isFalse);
    });

    test("Cannot generate resource when no workers assigned", () {
      expect(() => smith.generate(stock),
          throwsA(TypeMatcher<NotEnoughWorkers>()));
    });

    test("Cannot add more workers than allowed", () {
      smith.addWorker(Citizen());
      smith.addWorker(Citizen());
      smith.addWorker(Citizen());
      smith.addWorker(Citizen());
      smith.addWorker(Citizen());
      expect(() => smith.addWorker(Citizen()),
          throwsA(TypeMatcher<BuildingFull>()));
    });
  });
}
