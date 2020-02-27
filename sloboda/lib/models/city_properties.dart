import 'package:sloboda/models/sloboda_localizations.dart';

enum CITY_PROPERTIES { FAITH, DEFENSE, GLORY, CITIZENS, COSSACKS }

class CityProps {
  Map<CITY_PROPERTIES, int> _props = {
    CITY_PROPERTIES.GLORY: 1,
    CITY_PROPERTIES.DEFENSE: 1,
    CITY_PROPERTIES.CITIZENS: 15,
    CITY_PROPERTIES.FAITH: 1,
    CITY_PROPERTIES.COSSACKS: 0,
  };

  Map<CITY_PROPERTIES, int> asMap() {
    return Map.from(_props);
  }

  CityProps([Map<CITY_PROPERTIES, int> props]) {
    if (props != null) {
      _props = props;
    }
  }

  getByType(CITY_PROPERTIES type) {
    return _props[type];
  }

  addToType(CITY_PROPERTIES type, int amount) {
    _props[type] = _props[type] + amount;
    if (_props[type] < 0) {
      _props[type] = 0;
    }
  }

  removeFromType(CITY_PROPERTIES type, int amount) {
    _props[type] = _props[type] - amount;
    if (_props[type] < 0) {
      _props[type] = 0;
    }
  }

  List<CITY_PROPERTIES> getPropTypesKeys() {
    return _props.keys.toList();
  }

  static CityProps bigProps() {
    return CityProps({
      CITY_PROPERTIES.CITIZENS: 300,
      CITY_PROPERTIES.GLORY: 150,
      CITY_PROPERTIES.FAITH: 150,
      CITY_PROPERTIES.DEFENSE: 150,
      CITY_PROPERTIES.COSSACKS: 150,
    });
  }

  operator +(CityProps aProps) {
    if (aProps != null) {
      this._props.forEach((key, _) {
        if (aProps.getByType(key) != null) {
          this.addToType(key, aProps.getByType(key));
        }
      });
    }
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
