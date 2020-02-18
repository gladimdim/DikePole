import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:sloboda/models/buildings/city_buildings/church.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/city_properties.dart';
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

  int probability = 0;

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
    bool canHappen =
        Random().nextInt(100) < probability && satisfiesConditions(city);
    debugPrint(
        'Event: $localizedKey satisfies: ${satisfiesConditions(city)}, will happen: $canHappen');
    return canHappen;
  }

  RandomTurnEvent({this.localizedKey});

  static List<RandomTurnEvent> allEvents = [
    KoshoviyPohid(),
    TartarsRaid(),
    SaranaInvasion(),
    ChildrenPopulation(),
    SteppeFire(),
    RunnersFromSuppression(),
    SettlersArrived(),
    GuestsFromSich(),
    ChambulCapture(),
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
    return () {
      bool success = r > 8;
      return RandomEventMessage(
          event: this,
          stock: success ? stockSuccess : stockFailure,
          messageKey:
              success ? this.successMessageKey : this.failureMessageKey);
    };
  }

  Function makeChoice(bool yes, Sloboda city) {
    if (yes) {
      this.execute(city);
      return this.postExecute(city);
    } else {
      return () {};
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

  int probability = 30;

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
    },
    (Sloboda city) {
    bool canHappen =
       city.events
          .where(happenedInYearFn(city.currentYear))
          .where(eventHappenedFn<KoshoviyPohid>())
          .isEmpty;
    return canHappen;
    }
  ];

  Function postExecute(Sloboda city) {
    var r = Random().nextInt(100);
    return () {
      bool success = r <= 80;
      if (success) {
        city.props + CityProps({CITY_PROPERTIES.GLORY: 10});
      }
      return RandomEventMessage(
          event: this,
          stock: success ? stockSuccess : stockFailure,
          messageKey:
              success ? this.successMessageKey : this.failureMessageKey);
    };
  }
}

class TartarsRaid extends RandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successTartarRaid';
  String failureMessageKey = 'randomTurnEvent.failureTartarRaid';
  String localizedKey = 'randomTurnEvent.tartarRaid';
  int probability = 5;

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
        city.props + CityProps({CITY_PROPERTIES.GLORY: -1});
        return RandomEventMessage(
            event: this,
            stock: stockFailure,
            messageKey: this.failureMessageKey);
      } else {
        city.props + CityProps({CITY_PROPERTIES.GLORY: 5});
        return RandomEventMessage(
            event: this,
            stock: stockSuccess,
            messageKey: this.successMessageKey);
      }
    };
  }
}

class SaranaInvasion extends RandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successSaranaInvasion';
  String failureMessageKey = 'randomTurnEvent.failureSaranaInvasion';
  int probability = 5;

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
}

class ChildrenPopulation extends RandomTurnEvent {
  String localizedKey = 'randomTurnEvent.childrenPopulation';
  int probability = 100;
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
  int probability = 20;

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
}

class RunnersFromSuppression extends RandomTurnEvent {
  String localizedKey = 'randomTurnEvent.runnersFromSuppresion';
  int probability = 20;

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
}

class SettlersArrived extends RandomTurnEvent {
  String localizedKey = 'randomTurnEvent.settlersArrived';
  int probability = 20;

  Stock stockSuccess = Stock(
    {
      RESOURCE_TYPES.FOOD: 40,
      RESOURCE_TYPES.WOOD: 20,
      RESOURCE_TYPES.FIREARM: 15,
      RESOURCE_TYPES.HORSE: 10,
      RESOURCE_TYPES.IRON_ORE: 10,
      RESOURCE_TYPES.STONE: 10,
    },
  );

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is AutumnSeason;
    },
    (Sloboda city) {
      return city.props.getByType(CITY_PROPERTIES.GLORY) > 20;
    },
    (Sloboda city) {
      try {
        city.cityBuildings.firstWhere((element) => element is Church);
        return true;
      } catch (e) {
        return false;
      }
    }
  ];
}

class GuestsFromSich extends RandomTurnEvent {
  String localizedKey = 'randomTurnEvent.guestsFromSich';
  int probability = 30;

  Stock stockSuccess = Stock(
    {
      RESOURCE_TYPES.FOOD: 40,
      RESOURCE_TYPES.FIREARM: 20,
      RESOURCE_TYPES.HORSE: 10,
      RESOURCE_TYPES.POWDER: 20,
    },
  );

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is WinterSeason;
    },
    (Sloboda city) {
      return city.props.getByType(CITY_PROPERTIES.GLORY) > 10;
    },
  ];
}

class ChambulCapture extends RandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successChambulCapture';
  String failureMessageKey = 'randomTurnEvent.failureChambulCapture';
  String localizedKey = 'randomTurnEvent.steppeFire';
  int probability = 20;

  Stock stockSuccess = Stock(
    {
      RESOURCE_TYPES.HORSE: 20,
    },
  );

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is AutumnSeason;
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
}

Function eventHappenedFn<EventType>() {
  return (CityEvent event) =>
      event.events.where((subEvent) => subEvent.event is EventType).isNotEmpty;
}

Function happenedInYearFn(int year) {
  return (CityEvent event) => event.yearHappened == year;
}
