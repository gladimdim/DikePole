import 'package:sloboda/models/resources/resource.dart';

class Stock {
  Map<RESOURCE_TYPES, int> _stock = {
    RESOURCE_TYPES.FOOD: 150,
    RESOURCE_TYPES.FIREARM: 5,
    RESOURCE_TYPES.WOOD: 150,
    RESOURCE_TYPES.STONE: 130,
    RESOURCE_TYPES.IRON_ORE: 10,
    RESOURCE_TYPES.MONEY: 150,
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

  List getResourceTypesKeys() {
    return _stock.keys.toList();
  }
}
