import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
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
      expect(city.stock.keys.length, equals(4));
    });

    test("Inits with 15 citizens", () {
      expect(city.properties[CITY_PROPERTIES.CITIZENS], equals(15));
    });

    test("Inits with default buildings", () {
      expect(city.cityBuildings.length, equals(1));
    });
  });
}
