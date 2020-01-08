import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class Building {
  BUILDING_TYPES type;
  int output = 0;
  Map<RESOURCE_TYPES, int> input = Map();
  List<RESOURCE_TYPES> requires = [];
  RESOURCE_TYPES produces;
  List<Citizen> assignedHumans = [];

  void generated() {
    for (var r in requires) {
      if (input[r] > 0) {
        continue;
      } else {
        throw NotEnoughResourceException('Building $type has not enough: $r');
      }
    }

    output++;

    input.keys.forEach((key) {
      input[key] = input[key] - 1;
    });
  }

}

enum BUILDING_TYPES { SMITH }

class NotEnoughResourceException implements Exception {
  String cause;
  NotEnoughResourceException(this.cause);
}