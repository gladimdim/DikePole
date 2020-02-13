import 'package:sloboda/models/stock.dart';

class CityEvent {
  final int yearHappened;
  final CitySeason season;
  final List messages;
  final Stock stock;

  CityEvent({this.yearHappened, this.messages, this.season, this.stock});
}

abstract class CitySeason {
  CITY_SEASONS get type;

  String toLocalizedKey();

  CitySeason();
}

class WinterSeason extends CitySeason {
  CITY_SEASONS type = CITY_SEASONS.WINTER;

  String toLocalizedKey() {
    return 'winter';
  }
}

class SpringSeason extends CitySeason {
  CITY_SEASONS type = CITY_SEASONS.SPRING;

  String toLocalizedKey() {
    return 'spring';
  }
}

class SummerSeason extends CitySeason {
  CITY_SEASONS type = CITY_SEASONS.SUMMER;

  String toLocalizedKey() {
    return 'summer';
  }
}

class AutumnSeason extends CitySeason {
  CITY_SEASONS type = CITY_SEASONS.AUTUMN;

  String toLocalizedKey() {
    return 'autumn';
  }
}

enum CITY_SEASONS { AUTUMN, WINTER, SPRING, SUMMER }
