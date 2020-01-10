import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/house.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/mill.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:test/test.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';

void main() {
  group("Can be initialized with default params", () {
    var city = Sloboda(name: 'Dmitrova');
    test("Inits", () {
      expect(city, isNotNull);
      expect(city.name, equals('Dmitrova'));
    });

    test("Inits with default stock", () {
      expect(city.stock.keys.length, equals(10));
      expect(city.stock[RESOURCE_TYPES.FOOD], equals(50));
    });

    test("Inits with 15 citizens", () {
      expect(city.properties[CITY_PROPERTIES.CITIZENS], equals(15));
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
      city.removeResourceBuildingByType(BUILDING_TYPES.MILL);
      expect(city.resourceBuildings.length, equals(0));
      expect(city.getAllFreeCitizens().length, equals(15));
    });
  });

  group("Stock management", () {
    var city = Sloboda(name: 'Dimitrova');
    var field = ResourceBuilding.fromType(BUILDING_TYPES.FIELD);
    var smith = ResourceBuilding.fromType(BUILDING_TYPES.SMITH);
    field.addWorker(city.getFirstFreeCitizen());
    smith.addWorker(city.getFirstFreeCitizen());
    city.resourceBuildings.add(field);
    city.resourceBuildings.add(smith);

    test("Checks that two citizens are occupied", () {
      expect(city.getAllFreeCitizens().length, 13);
    });

    test("makeTurn for city with Field, Smith with 1 worker", () {
      city.makeTurn();
      expect(city.stock[RESOURCE_TYPES.FOOD], equals(53));
      expect(city.stock[RESOURCE_TYPES.IRON], equals(9));
      expect(city.stock[RESOURCE_TYPES.FIREARM], equals(6));
      expect(city.stock[RESOURCE_TYPES.SULFUR], equals(19));
    });

    test("makeTurn for city with Field with 2 workers, Smith with 1 worker", () {
      field.addWorker(city.citizens[2]);
      city.makeTurn();
      expect(city.getAllFreeCitizens().length, 12);
      expect(city.stock[RESOURCE_TYPES.FOOD], equals(61));
    });

  });
}
