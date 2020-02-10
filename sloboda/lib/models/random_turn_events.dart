import 'dart:math';

import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/stock.dart';

class RandomEventMessage {
  final Stock stock;
  final String messageKey;

  RandomEventMessage({this.stock, this.messageKey});
}

class RandomTurnEvent {
  String localizedKey;
  List<Function> conditions;
  Stock stockSuccess;
  Stock stockFailure;

  String successMessageKey;
  String failureMessageKey;

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
  String localizedKeyYes;
  String localizedKeyNo;

  Function execute(Sloboda city) {
    return () {};
  }

  Function postExecute(Sloboda city) {
    var r = Random().nextInt(10);
    return () => RandomEventMessage(
        stock: r > 5 ? stockSuccess : stockFailure, messageKey: r > 5 ? this.successMessageKey : this.failureMessageKey);
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
  String successMessageKey = 'randomTurnEvent.successKoshoviyPohid';
  String failureMessageKey = 'randomTurnEvent.failureKoshoviyPohid';
  String localizedKeyYes = 'randomTurnEvent.koshoviyPohidYes';
  String localizedKeyNo = 'randomTurnEvent.koshoviyPohidNo';

  Stock stockSuccess = Stock(
    {
      RESOURCE_TYPES.FOOD: 10,
      RESOURCE_TYPES.MONEY: 10,
    },
  );

  Stock stockFailure = Stock({
    RESOURCE_TYPES.FOOD: -10,
    RESOURCE_TYPES.FIREARM: -5,
  });

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
    if (satisfiesConditions(city)) {
      final r = Random();
      final v = r.nextInt(10);
      return v >= 5;
    } else {
      return false;
    }
  }
}

class TartarsRaid extends RandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successTartarRaid';
  String failureMessageKey = 'randomTurnEvent.failureTartarRaid';
  String localizedKey = 'randomTurnEvent.tartarRaid';

  Stock stockFailure = Stock(
    {
      RESOURCE_TYPES.FOOD: 20,
      RESOURCE_TYPES.HORSE: 3,
    },
  );

  Stock stockSuccess = Stock({
    RESOURCE_TYPES.FOOD: -10,
    RESOURCE_TYPES.MONEY: -5,
  });

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
      final r = Random().nextInt(10);
      if (r > 8) {
        return  RandomEventMessage(
            stock: stockFailure, messageKey: this.failureMessageKey);
      } else {
        return RandomEventMessage(
            stock: stockSuccess, messageKey: this.successMessageKey);
      }

    };
  }

  @override
  bool canHappen(Sloboda city) {
    if (satisfiesConditions(city)) {
      final r = Random();
      final v = r.nextInt(20);
      return v >= 15;
    } else {
      return false;
    }
  }
}