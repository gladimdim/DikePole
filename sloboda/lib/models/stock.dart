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
      RESOURCE_TYPES.FOOD: 500,
      RESOURCE_TYPES.FIREARM: 150,
      RESOURCE_TYPES.WOOD: 500,
      RESOURCE_TYPES.STONE: 300,
      RESOURCE_TYPES.IRON_ORE: 100,
      RESOURCE_TYPES.MONEY: 500,
      RESOURCE_TYPES.HORSE: 150,
      RESOURCE_TYPES.POWDER: 200,
      RESOURCE_TYPES.FUR: 50,
      RESOURCE_TYPES.FISH: 50,
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
