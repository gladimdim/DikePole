import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';

class ShootingRange implements Buildable<RESOURCE_TYPES> {
  CITY_PROPERTIES produces = CITY_PROPERTIES.COSSACKS;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 50,
    RESOURCE_TYPES.WOOD: 30,
  };
}
