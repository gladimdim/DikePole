import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/house.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:test/test.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';

void main() {
  group("Can be initialized", () {
    var city = Sloboda(name: 'Dmitrova');
    test("Inits", () {
      expect(city, isNotNull);
      expect(city.name, equals('Dmitrova'));
    });

    test("Inits with default stock", () {
      expect(city.stock.keys.length, equals(5));
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

  group("Stock management", () {
    var city = Sloboda(name: 'Dimitrova');
    var field = ResourceBuilding.fromType(BUILDING_TYPES.FIELD);
    var smith = ResourceBuilding.fromType(BUILDING_TYPES.SMITH);
    field.addWorker(city.citizens[0]);
    smith.addWorker(city.citizens[1]);
    city.resourceBuildings.add(field);
    city.resourceBuildings.add(smith);

    test("makeTurn for city with Field, Smith with 1 worker", () {
      city.makeTurn();
      expect(city.stock[RESOURCE_TYPES.FOOD], equals(53));
      expect(city.stock[RESOURCE_TYPES.IRON], equals(9));
      expect(city.stock[RESOURCE_TYPES.FIREARM], equals(6));
    });

    test("makeTurn for city with Field with 2 workers, Smith with 1 worker", () {
      field.addWorker(city.citizens[2]);
      city.makeTurn();
      expect(city.stock[RESOURCE_TYPES.FOOD], equals(61));
    });
  });
}
