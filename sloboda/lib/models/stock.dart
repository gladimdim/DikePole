import 'package:sloboda/models/resources/resource.dart';

class Stock {
  Map<RESOURCE_TYPES, int> _stock = {
    RESOURCE_TYPES.FOOD: 20,
    RESOURCE_TYPES.FIREARM: 1,
    RESOURCE_TYPES.WOOD: 15,
    RESOURCE_TYPES.STONE: 15,
    RESOURCE_TYPES.IRON_ORE: 1,
    RESOURCE_TYPES.MONEY: 0,
    RESOURCE_TYPES.HORSE: 5,
    RESOURCE_TYPES.POWDER: 5,
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
    if (_stock[type] < 0) {
      _stock[type] = 0;
    }
  }

  removeFromType(RESOURCE_TYPES type, int amount) {
    _stock[type] = _stock[type] - amount;
    if (_stock[type] < 0) {
      _stock[type] = 0;
    }
  }

  List getResourceTypesKeys() {
    return _stock.keys.toList();
  }

  static Stock bigStock() {
    return Stock({
      RESOURCE_TYPES.FOOD: 50,
      RESOURCE_TYPES.FIREARM: 5,
      RESOURCE_TYPES.WOOD: 50,
      RESOURCE_TYPES.STONE: 30,
      RESOURCE_TYPES.IRON_ORE: 10,
      RESOURCE_TYPES.MONEY: 50,
      RESOURCE_TYPES.HORSE: 10,
      RESOURCE_TYPES.POWDER: 20,
      RESOURCE_TYPES.FUR: 0,
      RESOURCE_TYPES.FISH: 0,
    });
  }

  operator +(Stock aStock) {
    if (aStock != null) {
      this._stock.forEach((key, _) {
        if (aStock.getByType(key) != null) {
          this.addToType(key, aStock.getByType(key));
        }
      });
    }
  }
}
