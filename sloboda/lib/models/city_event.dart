import 'package:flutter/foundation.dart';
import 'package:sloboda/models/events/random_turn_events.dart';

class CityEvent {
  final int yearHappened;
  final CitySeason season;
  final EventMessage sourceEvent;

  CityEvent({this.yearHappened, this.season, @required this.sourceEvent});

  static CityEvent copyFrom(CityEvent event) {
    return CityEvent(
      yearHappened: event.yearHappened,
      season: event.season,
      sourceEvent: event.sourceEvent,
    );
  }
}

abstract class CitySeason {
  CITY_SEASONS get type;

  set type(t) {
    throw 'Type cannot be changed';
  }

  String toLocalizedKey();

  CitySeason();
}

class WinterSeason extends CitySeason {
  CITY_SEASONS get type {
    return CITY_SEASONS.WINTER;
  }

  String toLocalizedKey() {
    return 'winter';
  }
}

class SpringSeason extends CitySeason {
  CITY_SEASONS get type {
    return CITY_SEASONS.SPRING;
  }

  String toLocalizedKey() {
    return 'spring';
  }
}

class SummerSeason extends CitySeason {
  CITY_SEASONS get type {
    return CITY_SEASONS.SUMMER;
  }

  String toLocalizedKey() {
    return 'summer';
  }
}

class AutumnSeason extends CitySeason {
  CITY_SEASONS get type {
    return CITY_SEASONS.AUTUMN;
  }

  String toLocalizedKey() {
    return 'autumn';
  }
}

enum CITY_SEASONS { AUTUMN, WINTER, SPRING, SUMMER }
