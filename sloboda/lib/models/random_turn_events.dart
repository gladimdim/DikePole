import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda.dart';

class RandomTurnEvent {
  String localizedKey;
  List<Function> conditions;

  bool satisfiesConditions(Sloboda city) {
    for (var func in conditions) {
      if (!func(city)) {
        return false;
      }
    }
    return true;
  }

  Function execute(Sloboda city) {
    throw UnimplementedError();
  }

  bool canHappen(Sloboda city) {
    throw UnimplementedError();
  }

  RandomTurnEvent({this.localizedKey});

  static List<RandomTurnEvent> allEvents = [KoshoviyPohid(), TartarsRaid()];
}

abstract class ChoicableRandomTurnEvent extends RandomTurnEvent {
  String localizedQuestionKey;

  Function execute(Sloboda city) {
    return () {};
  }

  Function postExecute(Sloboda city) {
    return () {};
  }

  Function makeChoice(bool yes, Sloboda city) {
    if (yes) {
      this.execute(city);
      return this.postExecute(city);
    } else {
      return () {
        city.properties[CITY_PROPERTIES.GLORY] -= 1;
      };
    }
  }
}

class KoshoviyPohid extends ChoicableRandomTurnEvent {
  String localizedKey = 'randomTurnEvent.koshoviyPohid';
  String localizedQuestionKey = 'randomTurnEvent.koshoviyPohidQuestion';
  List<Function> conditions = [
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.FIREARM) >= 1;
    },
    (Sloboda city) {
      return city.citizens.length > 10;
    }
  ];

  @override
  bool canHappen(Sloboda city) {
    return satisfiesConditions(city);
  }

  Function execute(Sloboda city) {
    return () {
      city.properties[CITY_PROPERTIES.GLORY] += 1;
    };
  }

  Function postExecute(Sloboda city) {
    return () {
      city.stock.addToType(RESOURCE_TYPES.MONEY, 10);
      city.stock.addToType((RESOURCE_TYPES.FOOD), 30);
    };
  }
}

class TartarsRaid extends ChoicableRandomTurnEvent {
  String localizedKey = 'randomTurnEvent.tartarRaid';
  List<Function> conditions = [
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.MONEY) >= 0;
    },
    (Sloboda city) {
      return city.citizens.length > 10;
    }
  ];

  Function execute(Sloboda city) {
    return () {
      city.properties[CITY_PROPERTIES.GLORY] += 1;
      city.properties[CITY_PROPERTIES.FAITH] += 1;
    };
  }

  Function postExecute(Sloboda city) {
    return () {
      city.stock.addToType(RESOURCE_TYPES.MONEY, 10);
      city.stock.addToType((RESOURCE_TYPES.FOOD), 30);
    };
  }

  @override
  bool canHappen(Sloboda city) {
    if (satisfiesConditions(city)) {
//      final r = Random();
//      final v = r.nextInt(20);
//      return v >= 5;
      return true;
    } else {
      return false;
    }
  }
}
