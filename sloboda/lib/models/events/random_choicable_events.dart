import 'dart:math';

import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
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

  CityProps cityPropsSuccess = CityProps(
    {
      CITY_PROPERTIES.GLORY: 10,
    },
  );
  CityProps cityPropsFailure = CityProps(
    {
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
      bool canHappen = city.events
          .where((event) => !happenedInLastYears(2, city.currentYear)(event))
          .where(eventHappenedFn<HelpNeighbours>())
          .isEmpty;
      return canHappen;
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
    {
      RESOURCE_TYPES.MONEY: 30,
      RESOURCE_TYPES.HORSE: 5,
      RESOURCE_TYPES.FUR: 10,
    },
  );

  Stock stockFailure = Stock({
    RESOURCE_TYPES.FOOD: -10,
    RESOURCE_TYPES.FIREARM: -5,
    RESOURCE_TYPES.HORSE: -5,
  });

  CityProps cityPropsSuccess = CityProps(
    {CITY_PROPERTIES.GLORY: 10, CITY_PROPERTIES.CITIZENS: 5},
  );
  CityProps cityPropsFailure = CityProps(
    {CITY_PROPERTIES.GLORY: 5, CITY_PROPERTIES.CITIZENS: -5},
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
      bool canHappen = city.events
          .where((event) => !happenedInLastYears(3, city.currentYear)(event))
          .where(eventHappenedFn<HelpNeighbours>())
          .isEmpty;
      return canHappen;
    }
  ];
}
