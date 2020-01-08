import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:test/test.dart';
import 'package:locadeserta/city_building/models/buildings/building.dart';

void main() {
  group("Building Forest", () {
    var forest = Building(type: BUILDING_TYPES.FOREST);
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
