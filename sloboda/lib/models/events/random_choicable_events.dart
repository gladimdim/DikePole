import 'dart:math';

import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/events/random_turn_events.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/stock.dart';

abstract class ChoicableRandomTurnEvent extends RandomTurnEvent {
  String localizedQuestionKey;
  String localizedKeyYes;
  String localizedKeyNo;
  CityProps cityPropsSuccess;
  CityProps cityPropsFailure;
  int successRate;

  Function execute(Sloboda city) {
    return () {};
  }

  Function postExecute(Sloboda city) {
    var r = Random().nextInt(100);
    return () {
      bool success = r <= successRate;
      return RandomEventMessage(
          event: this,
          stock: success ? stockSuccess : stockFailure,
          cityProps: success ? cityPropsSuccess : cityPropsFailure,
          messageKey:
              success ? this.successMessageKey : this.failureMessageKey);
    };
  }

  static bool onceInYears<T>(Sloboda city, int year) {
    bool canHappen = city.events
        .where((event) => !happenedInLastYears(year, city.currentYear)(event))
        .where(eventHappenedFn<T>())
        .isEmpty;
    return canHappen;
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
    values: {
      RESOURCE_TYPES.FOOD: 10,
      RESOURCE_TYPES.MONEY: 10,
    },
  );

  Stock stockFailure = Stock(values: {
    RESOURCE_TYPES.FOOD: -10,
    RESOURCE_TYPES.FIREARM: -5,
  });

  CityProps cityPropsSuccess = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: 10,
    },
  );
  CityProps cityPropsFailure = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: -5,
      CITY_PROPERTIES.CITIZENS: -10,
    },
  );
  int successRate = 80;

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
      return ChoicableRandomTurnEvent.onceInYears<KoshoviyPohid>(city, 2);
    }
  ];
}

class HelpNeighbours extends ChoicableRandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successHelpNeighbours';
  String failureMessageKey = 'randomTurnEvent.failureHelpNeighbours';
  String localizedKeyYes = 'randomTurnEvent.HelpNeighboursYes';
  String localizedKeyNo = 'randomTurnEvent.HelpNeighboursNo';

  int probability = 100;

  Stock stockSuccess = Stock(
    values: {
      RESOURCE_TYPES.MONEY: 30,
      RESOURCE_TYPES.HORSE: 5,
      RESOURCE_TYPES.FUR: 10,
    },
  );

  Stock stockFailure = Stock(values: {
    RESOURCE_TYPES.FOOD: -10,
    RESOURCE_TYPES.FIREARM: -5,
    RESOURCE_TYPES.HORSE: -5,
  });

  CityProps cityPropsSuccess = CityProps(
    values: {CITY_PROPERTIES.GLORY: 10, CITY_PROPERTIES.CITIZENS: 5},
  );
  CityProps cityPropsFailure = CityProps(
    values: {CITY_PROPERTIES.GLORY: 5, CITY_PROPERTIES.CITIZENS: -5},
  );

  int successRate = 80;

  String localizedKey = 'randomTurnEvent.HelpNeighbours';
  String localizedQuestionKey = 'randomTurnEvent.HelpNeighboursQuestion';

  List<Function> conditions = [
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.FIREARM) >= 10;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.HORSE) >= 10;
    },
    (Sloboda city) {
      return ChoicableRandomTurnEvent.onceInYears<HelpNeighbours>(city, 3);
    }
  ];
}

class BuyPrisoners extends ChoicableRandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successBuyPrisoners';
  String failureMessageKey = 'randomTurnEvent.failureBuyPrisoners';
  String localizedKeyYes = 'randomTurnEvent.BuyPrisonersYes';
  String localizedKeyNo = 'randomTurnEvent.BuyPrisonersNo';

  int probability = 100;

  Stock stockSuccess = Stock(values: {
    RESOURCE_TYPES.MONEY: -40,
  });

  Stock stockFailure = Stock(values: {
    RESOURCE_TYPES.MONEY: 20,
  });

  CityProps cityPropsFailure = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: 10,
      CITY_PROPERTIES.CITIZENS: 15,
      CITY_PROPERTIES.FAITH: 10,
    },
  );
  CityProps cityPropsSuccess = CityProps(
    values: {
      CITY_PROPERTIES.CITIZENS: 5,
    },
  );

  int successRate = 30;

  String localizedKey = 'randomTurnEvent.BuyPrisoners';
  String localizedQuestionKey = 'randomTurnEvent.BuyPrisonersQuestion';

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is AutumnSeason;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.MONEY) > 40;
    },
    (Sloboda city) {
      return ChoicableRandomTurnEvent.onceInYears<BuyPrisoners>(city, 3);
    }
  ];
}

class AttackChambul extends ChoicableRandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successAttackChambul';
  String failureMessageKey = 'randomTurnEvent.failureAttackChambul';
  String localizedKeyYes = 'randomTurnEvent.AttackChambulYes';
  String localizedKeyNo = 'randomTurnEvent.AttackChambulNo';

  int probability = 40;

  Stock stockSuccess = Stock(values: {
    RESOURCE_TYPES.HORSE: 20,
    RESOURCE_TYPES.MONEY: 40,
  });

  Stock stockFailure = Stock(values: {
    RESOURCE_TYPES.HORSE: -20,
    RESOURCE_TYPES.FIREARM: -20,
  });

  CityProps cityPropsSuccess = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: 40,
      CITY_PROPERTIES.FAITH: 10,
    },
  );
  CityProps cityPropsFailure = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: -20,
      CITY_PROPERTIES.FAITH: -5,
      CITY_PROPERTIES.CITIZENS: -20,
    },
  );

  int successRate = 50;

  String localizedKey = 'randomTurnEvent.AttackChambul';
  String localizedQuestionKey = 'randomTurnEvent.AttackChambulQuestion';

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is AutumnSeason;
    },
    (Sloboda city) {
      return ChoicableRandomTurnEvent.onceInYears<AttackChambul>(city, 2);
    }
  ];
}

class TrapChambulOnWayBack extends ChoicableRandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successTrapChambulOnWayBack';
  String failureMessageKey = 'randomTurnEvent.failureTrapChambulOnWayBack';
  String localizedKeyYes = 'randomTurnEvent.TrapChambulOnWayBackYes';
  String localizedKeyNo = 'randomTurnEvent.TrapChambulOnWayBackNo';

  int probability = 50;

  Stock stockSuccess = Stock(values: {
    RESOURCE_TYPES.HORSE: 50,
    RESOURCE_TYPES.MONEY: 200,
  });

  Stock stockFailure = Stock(values: {
    RESOURCE_TYPES.HORSE: -50,
    RESOURCE_TYPES.FIREARM: -50,
  });

  CityProps cityPropsSuccess = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: 80,
      CITY_PROPERTIES.FAITH: 20,
      CITY_PROPERTIES.CITIZENS: 40,
    },
  );
  CityProps cityPropsFailure = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: -50,
      CITY_PROPERTIES.FAITH: -40,
      CITY_PROPERTIES.CITIZENS: -80,
    },
  );

  int successRate = 50;

  String localizedKey = 'randomTurnEvent.TrapChambulOnWayBack';
  String localizedQuestionKey = 'randomTurnEvent.TrapChambulOnWayBackQuestion';

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is SummerSeason;
    },
    (Sloboda city) {
      return city.props.getByType(CITY_PROPERTIES.CITIZENS) > 300;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.FIREARM) > 100;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.HORSE) > 100;
    },
    (Sloboda city) {
      return ChoicableRandomTurnEvent.onceInYears<TrapChambulOnWayBack>(
          city, 7);
    }
  ];
}

class HelpDefendSich extends ChoicableRandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successHelpDefendSich';
  String failureMessageKey = 'randomTurnEvent.failureHelpDefendSich';
  String localizedKeyYes = 'randomTurnEvent.HelpDefendSichYes';
  String localizedKeyNo = 'randomTurnEvent.HelpDefendSichNo';

  int probability = 50;

  Stock stockSuccess = Stock(values: {
    RESOURCE_TYPES.HORSE: 10,
    RESOURCE_TYPES.FIREARM: 10,
  });

  Stock stockFailure = Stock(values: {
    RESOURCE_TYPES.HORSE: 5,
    RESOURCE_TYPES.FIREARM: 5,
  });

  CityProps cityPropsSuccess = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: 10,
      CITY_PROPERTIES.FAITH: 5,
    },
  );
  CityProps cityPropsFailure = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: 5,
      CITY_PROPERTIES.FAITH: 1,
    },
  );

  int successRate = 80;

  String localizedKey = 'randomTurnEvent.HelpDefendSich';
  String localizedQuestionKey = 'randomTurnEvent.HelpDefendSichQuestion';

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is SpringSeason;
    },
    (Sloboda city) {
      return city.props.getByType(CITY_PROPERTIES.CITIZENS) > 30;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.FIREARM) > 5;
    },
    (Sloboda city) {
      return ChoicableRandomTurnEvent.onceInYears<HelpDefendSich>(city, 4);
    }
  ];
}

class AttackPolishLands extends ChoicableRandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successAttackPolishLands';
  String failureMessageKey = 'randomTurnEvent.failureAttackPolishLands';
  String localizedKeyYes = 'randomTurnEvent.AttackPolishLandsYes';
  String localizedKeyNo = 'randomTurnEvent.AttackPolishLandsNo';

  int probability = 50;

  Stock stockSuccess = Stock(values: {
    RESOURCE_TYPES.HORSE: 50,
    RESOURCE_TYPES.FIREARM: 50,
    RESOURCE_TYPES.MONEY: 250,
    RESOURCE_TYPES.FOOD: 100,
  });

  Stock stockFailure = Stock(values: {
    RESOURCE_TYPES.HORSE: -50,
    RESOURCE_TYPES.FIREARM: -50,
    RESOURCE_TYPES.FOOD: -100,
  });

  CityProps cityPropsSuccess = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: 50,
      CITY_PROPERTIES.FAITH: 30,
    },
  );
  CityProps cityPropsFailure = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: -70,
      CITY_PROPERTIES.FAITH: -40,
    },
  );

  int successRate = 80;

  String localizedKey = 'randomTurnEvent.AttackPolishLands';
  String localizedQuestionKey = 'randomTurnEvent.AttackPolishLandsQuestion';

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is SpringSeason;
    },
    (Sloboda city) {
      return city.props.getByType(CITY_PROPERTIES.CITIZENS) > 50;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.FIREARM) > 50;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.HORSE) > 50;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.FOOD) > 200;
    },
    (Sloboda city) {
      return ChoicableRandomTurnEvent.onceInYears<AttackPolishLands>(city, 7);
    }
  ];
}

class SendMoneyToSchoolInKaniv extends ChoicableRandomTurnEvent {
  String successMessageKey = 'randomTurnEvent.successSendMoneyToSchoolInKaniv';
  String localizedKeyYes = 'randomTurnEvent.SendMoneyToSchoolInKanivYes';
  String localizedKeyNo = 'randomTurnEvent.SendMoneyToSchoolInKanivNo';

  int probability = 100;
  int successRate = 100;

  Stock stockSuccess = Stock(values: {
    RESOURCE_TYPES.MONEY: -40,
  });

  CityProps cityPropsSuccess = CityProps(
    values: {
      CITY_PROPERTIES.GLORY: 20,
      CITY_PROPERTIES.FAITH: 20,
    },
  );

  String localizedKey = 'randomTurnEvent.SendMoneyToSchoolInKaniv';
  String localizedQuestionKey =
      'randomTurnEvent.SendMoneyToSchoolInKanivQuestion';

  List<Function> conditions = [
    (Sloboda city) {
      return city.currentSeason is WinterSeason;
    },
    (Sloboda city) {
      return city.stock.getByType(RESOURCE_TYPES.MONEY) >= 40;
    },
    (Sloboda city) {
      return ChoicableRandomTurnEvent.onceInYears<SendMoneyToSchoolInKaniv>(
          city, 3);
    }
  ];
}
