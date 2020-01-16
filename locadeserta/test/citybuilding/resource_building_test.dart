import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/stock.dart';
import 'package:test/test.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';

void main() {
  group("Smith Main Tests", () {
    var smith = ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.SMITH);
    Stock stock = Stock({
      RESOURCE_TYPES.FOOD: 5,
      RESOURCE_TYPES.IRON: 5,
      RESOURCE_TYPES.FIREARM: 0,
      RESOURCE_TYPES.NITER: 1,
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

    test("Can generate wood with 1 worker", () {
      smith.generate(stock);
      expect(stock.getByType(RESOURCE_TYPES.FIREARM), equals(1));
      expect(stock.getByType(RESOURCE_TYPES.IRON), equals(4));
      expect(stock.getByType(RESOURCE_TYPES.FOOD), equals(3));
    });

    test("Can remove workers", () {
      var removedWorker = smith.removeWorker();
      expect(removedWorker, isNotNull);
      expect(smith.hasWorkers(), isFalse);
    });

    test("Cannot generate resource when no workers assigned", () {
      expect(() => smith.generate(stock),
          throwsA(TypeMatcher<NoWorkersAssignedException>()));
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
