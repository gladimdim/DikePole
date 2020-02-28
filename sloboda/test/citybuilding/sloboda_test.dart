import 'package:sloboda/models/buildings/city_buildings/house.dart';
import 'package:sloboda/models/buildings/resource_buildings/mill.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/buildings/resource_buildings/smith.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/stock.dart';
import 'package:test/test.dart';

void main() {
  group("Can be initialized with default params", () {
    var city = Sloboda(name: 'Dmitrova', stock: Stock.defaultStock());
    test("Inits", () {
      expect(city, isNotNull);
      expect(city.name, equals('Dmitrova'));
    });

    test("Inits with default stock", () {
      expect(city.stock.getTypeKeys().length, equals(10));
      expect(city.stock.getByType(RESOURCE_TYPES.FOOD), equals(20));
    });

    test("Inits with 15 citizens", () {
      expect(city.props.getByType(CITY_PROPERTIES.CITIZENS), equals(15));
    });

    test("Inits with default buildings", () {
      expect(city.cityBuildings.length, equals(1));
      expect(city.cityBuildings[0] is House, isTrue);
    });
  });

  group("Can manage resource buildings", () {
    var city = Sloboda(name: 'Dimitrova');
    test("Can add resource building", () {
      var mill = Mill();
      mill.addWorker(city.getFirstFreeCitizen());
      city.resourceBuildings.add(mill);
      expect(city.getAllFreeCitizens().length, equals(14));
      expect(city.resourceBuildings.length, equals(1));
    });

    test("Can remove resource building", () {
      city.removeResourceBuilding(city.resourceBuildings[0]);
      expect(city.resourceBuildings.length, equals(0));
      expect(city.getAllFreeCitizens().length, equals(15));
    });
  });

  group("Stock management", () {
    var city = Sloboda(name: 'Dimitrova');
    var field = ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.FIELD);
    var smith = ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.SMITH);
    field.addWorker(city.getFirstFreeCitizen());
    smith.addWorker(city.getFirstFreeCitizen());
    city.resourceBuildings.add(field);
    city.resourceBuildings.add(smith);

    test("Checks that two citizens are occupied", () {
      expect(city.getAllFreeCitizens().length, 13);
    });

    test("makeTurn for city with Field, Smith with 1 worker", () {
      city.makeTurn();
      expect(city.stock.getByType(RESOURCE_TYPES.FOOD), equals(23));
      expect(city.stock.getByType(RESOURCE_TYPES.FIREARM), equals(2));
      expect(city.stock.getByType(RESOURCE_TYPES.POWDER), equals(4));
    });

    test("makeTurn for city with Field with 2 workers, Smith with 1 worker",
        () {
      field.addWorker(city.citizens[2]);
      city.makeTurn();
      expect(city.getAllFreeCitizens().length, 14);
      expect(city.stock.getByType(RESOURCE_TYPES.FOOD), equals(33));
    });
  });

  group(
    'City events management',
    () {
      var city = Sloboda(name: 'Dimitrova');
      var field = ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.FIELD);
      city.buildBuilding(field);

      test('City inits without events', () {
        expect(city.events.isEmpty, true);
      });

      test(
        'Generates three events for no workers assigned to default Forest and River and new Field',
        () {
          city.makeTurn();
          expect(
            city.events.length,
            equals(1),
          );

          expect(
            city.events.length,
            equals(3),
          );
        },
      );

      test(
        'Generates two more events for no workers assigned to default Forest and River',
        () {
          field.addWorker(Citizen());
          city.makeTurn();
          expect(
            city.events.length,
            equals(5),
          );
        },
      );

      test(
        'Generates no additional events when Forest and River have workers',
        () {
          city.naturalResources[0].addWorker(city.getFirstFreeCitizen());
          city.naturalResources[1].addWorker(city.getFirstFreeCitizen());
          city.makeTurn();
          expect(
            city.events.length,
            equals(5),
          );
        },
      );

      test(
        'Generates one additional event when Smith has no IRON for input',
        () {
          var smith = Smith();
          city.buildBuilding(smith);
          smith.addWorker(city.getFirstFreeCitizen());
          // iron is 1 before this turn
          city.makeTurn();
          // iron is 0 after this turn
          city.makeTurn();
          expect(
            city.events.length,
            equals(6),
          );
        },
      );
    },
  );
}
