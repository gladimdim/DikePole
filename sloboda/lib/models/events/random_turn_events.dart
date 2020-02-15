import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/stock.dart';

class RandomEventMessage {
  final Stock stock;
  final String messageKey;
  final RandomTurnEvent event;

  RandomEventMessage({this.stock, this.messageKey, @required this.event});
}

abstract class RandomTurnEvent {
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
    return () {
      return RandomEventMessage(
        event: this,
        stock: stockSuccess,
        messageKey: this.localizedKey,
      );
    };
  }

  bool canHappen(Sloboda city) {
    return satisfiesConditions(city);
  }

  RandomTurnEvent({this.localizedKey});

  static List<RandomTurnEvent> allEvents = [
    KoshoviyPohid(),
    TartarsRaid(),
    SaranaInvasion(),
    ChildrenPopulation(),
    SteppeFire(),
    RunnersFromSuppression(),
  ];
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
        event: this,
        stock: r > 5 ? stockSuccess : stockFailure,
        messageKey: r > 5 ? this.successMessageKey : this.failureMessageKey);
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

  String choiceToStringKey(bool yes) {
    return yes ? localizedKeyYes : localizedKeyNo;
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
      return v >= 8;
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
      return city.stock.getByType(RESOURCE_TYPES.FOOD) >= 50;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.MONEY) >= 100;
    },
    (Sloboda city) {
      return city.citizens.length > 40;
    }
  ];

  Function execute(Sloboda city) {
    return () {
      final r = Random().nextInt(10);
      if (r > 8) {
        return RandomEventMessage(
            event: this,
            stock: stockFailure,
            messageKey: this.failureMessageKey);
      } else {
        return RandomEventMessage(
            event: this,
            stock: stockSuccess,
            messageKey: this.successMessageKey);
      }
    };
  }

  @override
  bool canHappen(Sloboda city) {
    if (satisfiesConditions(city)) {
      return Random().nextInt(100) <= 5;
    } else {
      return false;
    }
  }
}

class SaranaInvasion extends RandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successSaranaInvasion';
  String failureMessageKey = 'randomTurnEvent.failureSaranaInvasion';

  Stock stockSuccess = Stock(
    {
      RESOURCE_TYPES.FOOD: -5,
      RESOURCE_TYPES.HORSE: -1,
    },
  );

  Stock stockFailure = Stock(
    {},
  );

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is SpringSeason;
    },
  ];

  Function execute(Sloboda city) {
    return () {
      final r = Random().nextInt(10);
      if (r >= 4) {
        return RandomEventMessage(
            event: this,
            stock: stockFailure,
            messageKey: this.failureMessageKey);
      } else {
        return RandomEventMessage(
            event: this,
            stock: stockSuccess,
            messageKey: this.successMessageKey);
      }
    };
  }

  @override
  bool canHappen(Sloboda city) {
    if (satisfiesConditions(city)) {
      return Random().nextInt(100) <= 5;
    } else {
      return false;
    }
  }
}

class ChildrenPopulation extends RandomTurnEvent {
  String localizedKey = 'randomTurnEvent.childrenPopulation';

  Stock stockSuccess = Stock(
    {},
  );

  Stock stockFailure = Stock(
    {},
  );

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentYear % 5 == 0;
    },
    (Sloboda city) {
      return city.currentSeason is SpringSeason;
    }
  ];

  Function execute(Sloboda city) {
    return () {
      city.addCitizens(amount: 5);

      return RandomEventMessage(
        event: this,
        stock: stockSuccess,
        messageKey: this.localizedKey,
      );
    };
  }
}

class SteppeFire extends RandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successSteppeFire';
  String failureMessageKey = 'randomTurnEvent.failureSteppeFire';
  String localizedKey = 'randomTurnEvent.steppeFire';

  Stock stockSuccess = Stock(
    {
      RESOURCE_TYPES.FOOD: -5,
      RESOURCE_TYPES.WOOD: -20,
      RESOURCE_TYPES.POWDER: -30,
      RESOURCE_TYPES.HORSE: -2,
    },
  );

  Stock stockFailure = Stock(
    {
      RESOURCE_TYPES.FOOD: 20,
      RESOURCE_TYPES.WOOD: 10,
      RESOURCE_TYPES.HORSE: 10,
    },
  );

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is SummerSeason;
    }
  ];

  Function execute(Sloboda city) {
    return () {
      if (Random().nextInt(100) <= 50) {
        return RandomEventMessage(
          event: this,
          stock: stockSuccess,
          messageKey: this.successMessageKey,
        );
      } else {
        return RandomEventMessage(
          event: this,
          stock: stockFailure,
          messageKey: this.failureMessageKey,
        );
      }
    };
  }

  bool canHappen(Sloboda city) {
    return Random().nextInt(100) <= 20 && satisfiesConditions(city);
  }
}

class RunnersFromSuppression extends RandomTurnEvent {
  String localizedKey = 'randomTurnEvent.runnersFromSuppresion';

  Stock stockSuccess = Stock(
    {
      RESOURCE_TYPES.FOOD: 15,
      RESOURCE_TYPES.WOOD: 10,
      RESOURCE_TYPES.FIREARM: 5,
      RESOURCE_TYPES.HORSE: 2,
      RESOURCE_TYPES.IRON_ORE: 5,
      RESOURCE_TYPES.STONE: 5,
    },
  );

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is SummerSeason;
    },
    (Sloboda city) {
      return city.currentYear % 3 == 0;
    }
  ];

  bool canHappen(Sloboda city) {
    return Random().nextInt(100) <= 20 && satisfiesConditions(city);
  }
}
