import 'package:flutter/widgets.dart';
import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';

class ShootingRange implements Buildable<RESOURCE_TYPES> {
  CITY_PROPERTIES produces = CITY_PROPERTIES.COSSACKS;
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 50,
    RESOURCE_TYPES.WOOD: 30,
  };

  Widget build(BuildContext context, Function callback) {
    return Container(
      child: Text('Shooting range'),
    );
  }

  get icon {
    return 'images/city_buildings/shooting_range_64.png';
  }

  get image {
    return 'images/city_buildings/shooting_range.png';
  }
}
