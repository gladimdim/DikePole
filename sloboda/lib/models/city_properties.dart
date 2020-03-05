import 'package:sloboda/models/abstract/stockable.dart';
import 'package:sloboda/models/sloboda_localizations.dart';

enum CITY_PROPERTIES { FAITH, DEFENSE, GLORY, CITIZENS, COSSACKS }

abstract class StockItem<T> {
  String localizedKey;
  String localizedDescriptionKey;
  T type;
  int value;

  StockItem([this.value]);

  String toLocalizedString() {
    return SlobodaLocalizations.getForKey(localizedKey);
  }

  String toLocalizedDescriptionString() {
    return SlobodaLocalizations.getForKey(localizedDescriptionKey);
  }

  String toImagePath();

  String toIconPath();

  static StockItem fromType(CITY_PROPERTIES type, [int value]) {
    switch (type) {
      case CITY_PROPERTIES.FAITH:
        return CityFaith(value);
      case CITY_PROPERTIES.GLORY:
        return CityGlory(value);
      case CITY_PROPERTIES.DEFENSE:
        return CityDefense(value);
      case CITY_PROPERTIES.CITIZENS:
        return CityCitizens(value);
      case CITY_PROPERTIES.COSSACKS:
        return CityCossacks(value);
      default:
        throw 'Type $type is not recognized';
    }
  }
}

class CityFaith extends StockItem<CITY_PROPERTIES> {
  String localizedKey = 'cityProps.faith';
  String localizedDescriptionKey = 'cityProps.faithDescription';
  CITY_PROPERTIES type = CITY_PROPERTIES.FAITH;

  String toImagePath() {
    return 'images/city_props/faith.png';
  }

  String toIconPath() {
    return 'images/city_props/faith_64.png';
  }

  CityFaith([value]) : super(value);
}

class CityGlory extends StockItem<CITY_PROPERTIES> {
  String localizedKey = 'cityProps.glory';
  String localizedDescriptionKey = 'cityProps.gloryDescription';
  CITY_PROPERTIES type = CITY_PROPERTIES.GLORY;

  String toImagePath() {
    return 'images/city_props/glory.png';
  }

  String toIconPath() {
    return 'images/city_props/glory_64.png';
  }

  CityGlory([value]) : super(value);
}

class CityDefense extends StockItem<CITY_PROPERTIES> {
  String localizedKey = 'cityProps.defense';
  String localizedDescriptionKey = 'cityProps.defenseDescription';
  CITY_PROPERTIES type = CITY_PROPERTIES.DEFENSE;

  String toImagePath() {
    return 'images/city_props/defense.png';
  }

  String toIconPath() {
    return 'images/city_props/defense_64.png';
  }

  CityDefense([value]) : super(value);
}

class CityCitizens extends StockItem<CITY_PROPERTIES> {
  String localizedKey = 'cityProps.citizens';
  String localizedDescriptionKey = 'cityProps.citizensDescription';
  CITY_PROPERTIES type = CITY_PROPERTIES.CITIZENS;

  String toImagePath() {
    return 'images/city_props/citizen.png';
  }

  String toIconPath() {
    return 'images/city_props/citizen_64.png';
  }

  CityCitizens([value]) : super(value);
}

class CityCossacks extends StockItem<CITY_PROPERTIES> {
  String localizedKey = 'cityProps.cossacks';
  String localizedDescriptionKey = 'cityProps.cossacksDescription';
  CITY_PROPERTIES type = CITY_PROPERTIES.COSSACKS;

  String toImagePath() {
    return 'images/city_props/cossack.png';
  }

  String toIconPath() {
    return 'images/city_props/cossack_64.png';
  }

  CityCossacks([value]) : super(value);
}

class CityProps extends Stockable<CITY_PROPERTIES> {
  static const Map<CITY_PROPERTIES, int> defaultValues = {
    CITY_PROPERTIES.GLORY: 1,
    CITY_PROPERTIES.DEFENSE: 1,
    CITY_PROPERTIES.CITIZENS: 15,
    CITY_PROPERTIES.FAITH: 1,
    CITY_PROPERTIES.COSSACKS: 0,
  };

  CityProps({Map<CITY_PROPERTIES, int> values}) : super(values);

  static CityProps defaultProps() {
    return CityProps(values: defaultValues);
  }

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
