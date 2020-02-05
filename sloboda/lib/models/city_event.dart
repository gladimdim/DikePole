class CityEvent {
  final int yearHappened;
  final CITY_SEASONS season;
  final List messages;

  CityEvent({this.yearHappened, this.messages, this.season});
}

enum CITY_SEASONS { AUTUMN, WINTER, SPRING, SUMMER}

String citySeasonToString(CITY_SEASONS season) {
  switch (season) {
    case CITY_SEASONS.AUTUMN: return 'autumn';
    case CITY_SEASONS.SPRING: return 'spring';
    case CITY_SEASONS.SUMMER: return 'summer';
    case CITY_SEASONS.WINTER: return 'winter';
    default: throw 'Season $season is not recognized';
  }
}