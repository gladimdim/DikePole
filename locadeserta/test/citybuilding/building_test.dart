import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:test/test.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';

void main() {
  group("Building Main Tests", () {
    var forest = ResourceBuilding.fromType(BUILDING_TYPES.SMITH);
    test("Inits with zero stock", () {
      expect(forest.stock, equals(0));
    });

    test("Does not require other resources", () {
      expect(forest.requires, isEmpty);
    });

    test("Can add worker", () {
      forest.addWorker(Citizen());
      expect(forest.hasWorkers(), isTrue);
    });

    test("Can tell if workers are assigned", () {
      expect(forest.hasWorkers(), isTrue);
    });

    test("Can generate wood with 1 worker", () {
      forest.generate();
      expect(forest.stock, equals(1));
    });

    test("Can remove workers", () {
      var removedWorker = forest.removeWorker();
      expect(removedWorker, isNotNull);
      expect(forest.hasWorkers(), isFalse);
    });

    test("Cannot generate resource when no workers assigned", () {
      expect(() => forest.generate(),
          throwsA(TypeMatcher<NoWorkersAssignedException>()));
    });
  });
}
