import 'package:sloboda/models/abstract/comparable_maps.dart';
import 'package:sloboda/models/sloboda_localizations.dart';

enum CITY_PROPERTIES { FAITH, DEFENSE, GLORY, CITIZENS, COSSACKS }

class CityProps extends Stockable<CITY_PROPERTIES> {
  static const Map<CITY_PROPERTIES, int> defaultValues = {
    CITY_PROPERTIES.GLORY: 1,
    CITY_PROPERTIES.DEFENSE: 1,
    CITY_PROPERTIES.CITIZENS: 15,
    CITY_PROPERTIES.FAITH: 1,
    CITY_PROPERTIES.COSSACKS: 0,
  };

  CityProps({Map<CITY_PROPERTIES, int> values = CityProps.defaultValues})
      : super(values);

  static CityProps bigProps() {
    return CityProps(values: {
      CITY_PROPERTIES.CITIZENS: 300,
      CITY_PROPERTIES.GLORY: 150,
      CITY_PROPERTIES.FAITH: 150,
      CITY_PROPERTIES.DEFENSE: 150,
      CITY_PROPERTIES.COSSACKS: 150,
    });
  }
}

String cityPropsToLocalizedString(CITY_PROPERTIES type) {
  switch (type) {
    case CITY_PROPERTIES.GLORY:
      return SlobodaLocalizations.glory;
    case CITY_PROPERTIES.CITIZENS:
      return SlobodaLocalizations.citizens;
    case CITY_PROPERTIES.FAITH:
      return SlobodaLocalizations.faith;
    case CITY_PROPERTIES.DEFENSE:
      return SlobodaLocalizations.defense;
    case CITY_PROPERTIES.COSSACKS:
      return 'Cossacks';
  }
}

String cityPropertiesToIconPath(CITY_PROPERTIES prop) {
  switch (prop) {
    case CITY_PROPERTIES.CITIZENS:
      return 'images/city_buildings/citizen_64.png';
    case CITY_PROPERTIES.DEFENSE:
      return 'images/city_props/defense_64.png';
    case CITY_PROPERTIES.FAITH:
      return 'images/city_props/faith_64.png';
    case CITY_PROPERTIES.GLORY:
      return 'images/city_props/glory_64.png';
    case CITY_PROPERTIES.COSSACKS:
      return 'images/city_props/citizen_64.png';
  }
}
