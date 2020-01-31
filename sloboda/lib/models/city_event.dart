class CityEvent {
  final int yearHappened;
  final CITY_SEASONS season;
  final List messages;

  CityEvent({this.yearHappened, this.messages, this.season});
}

enum CITY_SEASONS { AUTUMN, WINTER, SPRING, SUMMER}

String citySeasonToString(CITY_SEASONS season) {
  switch (season) {
    case CITY_SEASONS.AUTUMN: return 'Autumn';
    case CITY_SEASONS.SPRING: return 'Spring';
    case CITY_SEASONS.SUMMER: return 'Summer';
    case CITY_SEASONS.WINTER: return 'Winter';
  }
}