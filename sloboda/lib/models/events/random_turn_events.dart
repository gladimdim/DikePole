import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:sloboda/models/buildings/city_buildings/church.dart';
import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/events/random_choicable_events.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/stock.dart';

class EventMessage {
  final Stock stock;
  String messageKey;
  final RandomTurnEvent event;
  final CityProps cityProps;

  EventMessage(
      {this.stock,
      @required this.messageKey,
      @required this.event,
      this.cityProps});
}

abstract class RandomTurnEvent {
  String localizedKey;
  List<Function> conditions;
  Stock stockSuccess;
  Stock stockFailure;

  CityProps cityPropsSuccess;
  CityProps cityPropsFailure;

  String successMessageKey;
  String failureMessageKey;

  int probability = 0;
  int successRate = 0;

  bool satisfiesConditions(Sloboda city) {
    for (var func in conditions) {
      if (!func(city)) {
        return false;
      }
    }
    return true;
  }

  Function execute(Sloboda city) {
    var r = Random().nextInt(100);
    return () {
      bool success = r <= successRate;
      return EventMessage(
          event: this,
          stock: success ? stockSuccess : stockFailure,
          cityProps: success ? cityPropsSuccess : cityPropsFailure,
          messageKey:
              success ? this.successMessageKey : this.failureMessageKey);
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
    MerchantVisit(),
    UniteWithNeighbours(),
    HelpNeighbours(),
    BuyPrisoners(),
    AttackChambul(),
    TrapChambulOnWayBack(),
    HelpDefendSich(),
    SendMoneyToSchoolInKaniv(),
    SendMerchantToKanev(),
    AttackCatholicChurches(),
    HelpDefendAgainstCatholicRaiders(),
  ];
}

class TartarsRaid extends RandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successTartarRaid';
  String failureMessageKey = 'randomTurnEvent.failureTartarRaid';
  String localizedKey = 'randomTurnEvent.tartarRaid';
  int probability = 20;
  int successRate = 20;

  Stock stockFailure = Stock(
    values: {
      RESOURCE_TYPES.FOOD: 20,
      RESOURCE_TYPES.HORSE: 3,
    },
  );

  Stock stockSuccess = Stock(values: {
    RESOURCE_TYPES.FOOD: -30,
    RESOURCE_TYPES.MONEY: -50,
  });

  CityProps cityPropsSuccess = CityProps(values: {CITY_PROPERTIES.GLORY: -10});
  CityProps cityPropsFailure = CityProps(values: {CITY_PROPERTIES.GLORY: 10});

  List<Function> conditions = [
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.FOOD) >= 50;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.MONEY) >= 100;
    },
    (Sloboda city) {
      return !(city.currentSeason is WinterSeason);
    },
    (Sloboda city) {
      return city.citizens.length > 40;
    }
  ];
}

class SaranaInvasion extends RandomTurnEvent {
  String localizedKey = 'randomTurnEvent.saranaInvasion';
  String successMessageKey = 'randomTurnEvent.successSaranaInvasion';
  String failureMessageKey = 'randomTurnEvent.failureSaranaInvasion';
  int probability = 50;
  int successRate = 40;

  Stock stockSuccess = Stock(
    values: {
      RESOURCE_TYPES.FOOD: -50,
      RESOURCE_TYPES.HORSE: -10,
    },
  );

  Stock stockFailure = Stock();

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is SpringSeason;
    },
  ];
}

class ChildrenPopulation extends RandomTurnEvent {
  String localizedKey = 'randomTurnEvent.childrenPopulation';
  int probability = 100;
  int successRate = 100;
  Stock stockSuccess = Stock();

  Stock stockFailure = Stock();

  CityProps cityPropsSuccess = CityProps(values: {CITY_PROPERTIES.CITIZENS: 5});

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
      return EventMessage(
        event: this,
        stock: stockSuccess,
        cityProps: cityPropsSuccess,
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
  int successRate = 50;

  Stock stockSuccess = Stock(
    values: {
      RESOURCE_TYPES.FOOD: -5,
      RESOURCE_TYPES.WOOD: -20,
      RESOURCE_TYPES.POWDER: -30,
      RESOURCE_TYPES.HORSE: -2,
    },
  );

  Stock stockFailure = Stock(
    values: {
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
}

class RunnersFromSuppression extends RandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.runnersFromSuppresion';
  int probability = 20;
  int successRate = 100;

  Stock stockSuccess = Stock(
    values: {
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
  String successMessageKey = 'randomTurnEvent.settlersArrived';
  int probability = 20;
  int successRate = 100;

  Stock stockSuccess = Stock(
    values: {
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
  String successMessageKey = 'randomTurnEvent.guestsFromSich';
  int probability = 30;
  int successRate = 100;

  Stock stockSuccess = Stock(
    values: {
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
      return city.props.getByType(CITY_PROPERTIES.GLORY) > 50;
    },
  ];
}

class ChambulCapture extends RandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successChambulCapture';
  String failureMessageKey = 'randomTurnEvent.failureChambulCapture';
  int probability = 20;
  int successRate = 50;

  Stock stockSuccess = Stock(
    values: {
      RESOURCE_TYPES.HORSE: 20,
    },
  );

  Stock stockFailure = Stock();

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is AutumnSeason;
    },
    (Sloboda city) {
      return city.props.getByType(CITY_PROPERTIES.COSSACKS) >= 10;
    },
  ];
}

class MerchantVisit extends RandomTurnEvent {
  String localizedKey = 'randomTurnEvent.merchantVisit';
  int probability = 100;

  Function execute(Sloboda city) {
    var fur = city.stock.getByType(
      RESOURCE_TYPES.FUR,
    );

    var fish = city.stock.getByType(
      RESOURCE_TYPES.FISH,
    );
    var stock = Stock(values: {
      RESOURCE_TYPES.FUR: -fur,
      RESOURCE_TYPES.FISH: -fish,
      RESOURCE_TYPES.MONEY: (fur + fish) * 2,
    });
    return () {
      return EventMessage(
        event: this,
        stock: stock,
        messageKey: this.localizedKey,
      );
    };
  }

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is AutumnSeason;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.FUR) >= 20;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.FISH) >= 20;
    }
  ];
}

class UniteWithNeighbours extends RandomTurnEvent {
  String localizedKey = 'randomTurnEvent.uniteWithNeighbours';
  int probability = 100;

  Stock stockSuccess = Stock(values: {
    RESOURCE_TYPES.FUR: 30,
    RESOURCE_TYPES.FISH: 30,
    RESOURCE_TYPES.MONEY: 50,
    RESOURCE_TYPES.FOOD: 100,
    RESOURCE_TYPES.WOOD: 100,
    RESOURCE_TYPES.STONE: 100,
  });

  Function execute(Sloboda city) {
    return () {
      return EventMessage(
        event: this,
        stock: stockSuccess,
        cityProps: CityProps(values: {CITY_PROPERTIES.CITIZENS: 20}),
        messageKey: this.localizedKey,
      );
    };
  }

  List<Function> conditions = [
    (Sloboda city) {
      try {
        city.cityBuildings.firstWhere((element) => element is Church);
        return true;
      } catch (e) {
        return false;
      }
    },
    (Sloboda city) {
      return city.events.where(eventHappenedFn<UniteWithNeighbours>()).isEmpty;
    },
    (Sloboda city) {
      return city.props.getByType(CITY_PROPERTIES.GLORY) > 20;
    },
    (Sloboda city) {
      return city.props.getByType(CITY_PROPERTIES.DEFENSE) > 20;
    }
  ];
}

Function eventHappenedFn<EventType>() {
  return (CityEvent event) => event.sourceEvent.event is EventType;
}

Function happenedInYearFn(int year) {
  return (CityEvent event) => event.yearHappened == year;
}

Function happenedInLastYears(int amountOfYearsBack, int currentYear) {
  return (CityEvent event) =>
      ((currentYear - event.yearHappened) > amountOfYearsBack);
}
