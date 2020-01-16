import 'package:locadeserta/city_building/models/resources/resource.dart';

class Stock {
  Map<RESOURCE_TYPES, int> _stock = {
    RESOURCE_TYPES.FOOD: 50,
    RESOURCE_TYPES.FIREARM: 5,
    RESOURCE_TYPES.WOOD: 50,
    RESOURCE_TYPES.STONE: 30,
    RESOURCE_TYPES.IRON: 10,
    RESOURCE_TYPES.MONEY: 50,
    RESOURCE_TYPES.HORSE: 10,
    RESOURCE_TYPES.NITER: 20,
    RESOURCE_TYPES.FUR: 0,
    RESOURCE_TYPES.FISH: 0,
  };

  Stock([Map<RESOURCE_TYPES, int> stock]) {
    if (stock != null) {
      _stock = stock;
    }
  }


  getByType(RESOURCE_TYPES type) {
    return _stock[type];
  }

  addToType(RESOURCE_TYPES type, int amount) {
    _stock[type] = _stock[type] + amount;
  }

  removeFromType(RESOURCE_TYPES type, int amount) {
    _stock[type] = _stock[type] - amount;
  }

  getResourceTypesKeys() {
    return _stock.keys.toList();
  }
}
