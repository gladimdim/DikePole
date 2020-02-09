import 'dart:core';
import 'package:sloboda/loaders/url_parser.dart';
import 'package:flutter/material.dart';
import 'package:sloboda/models/app_preferences.dart';

var version = "0.010";

String getDefaultOrUrlLanguage() {
  var urlLang = UrlParser.getLanguage();
  final savedLangCode = AppPreferences.instance.getUILanguage();
  if (SlobodaLocalizations.supportedLanguageCodes.contains(urlLang)) {
    return urlLang;
  } else if (savedLangCode != null &&
      SlobodaLocalizations.supportedLanguageCodes.contains(savedLangCode)) {
    return savedLangCode;
  } else {
    return 'en';
  }
}

class InternalLocalizations {
  Map<String, Map<String, String>> _localizedMap;

  String operator [](String key) {
    final lang = _localizedMap[SlobodaLocalizations.locale.languageCode];

    if (lang.containsKey(key)) {
      return lang[key];
    } else {
      return key;
    }
  }
}

class CityBuildingLocalizations extends InternalLocalizations {
  Map<String, Map<String, String>> _localizedMap = {
    'en': {
      'house': 'House',
      'wall': 'Wall',
      'tower': 'Tower',
      'watchTower': 'Watch Tower',
      'church': 'Church',
    },
    'uk': {
      'house': 'Курінь',
      'wall': 'Частокол',
      'tower': 'Башта',
      'watchTower': 'Хфігура',
      'church': 'Церква',
    }
  };
}

class ResourceLocalizations extends InternalLocalizations {
  Map<String, Map<String, String>> _localizedMap = {
    'en': {
      'food': 'Food',
      'stone': 'Stone',
      'wood': 'Wood',
      'ore': 'Ore',
      'money': 'Money',
      'horse': 'Horse',
      'powder': 'Powder',
      'fur': 'Fur',
      'fish': 'Fish',
      'firearm': 'Firearm',
    },
    'uk': {
      'food': 'Їжа',
      'stone': 'Каміння',
      'wood': 'Дерево',
      'ore': 'Руда',
      'money': 'Гроші',
      'horse': 'Коні',
      'powder': 'Порох',
      'fur': 'Хутра',
      'fish': 'Риба',
      'firearm': 'Самопал'
    }
  };
}

class ResourceBuildingsLocalizations extends InternalLocalizations {
  Map<String, Map<String, String>> _localizedMap = {
    'en': {
      'mill': 'Mill',
      'field': 'Field',
      'quarry': 'Quarry',
      'smith': 'Smith',
      'stables': 'Stables',
      'ironMine': 'Iron Mine',
      'trapperCabin': 'Trapper\'s Cabin',
      'powderCellar': 'Powder Cellar',
    },
    'uk': {
      'mill': 'Млин',
      'field': 'Поле',
      'quarry': 'Каменярня',
      'smith': 'Кузня',
      'stables': 'Конюшня',
      'ironMine': 'Рудня',
      'trapperCabin': 'Хата уходника',
      'powderCellar': 'Пороховий льох'
    }
  };
}

class NatureResourceBuildingsLocalizations extends InternalLocalizations {
  Map<String, Map<String, String>> _localizedMap = {
    'en': {
      'forest': 'Forest',
      'river': 'River',
    },
    'uk': {
      'forest': 'Ліс',
      'river': 'Річка',
    }
  };
}

class RandomEventLocalizations extends InternalLocalizations {
  Map<String, Map<String, String>> _localizedMap = {
    'en': {
      'koshoviyPohid': 'Quick raid.',
      'tartarRaid': 'Tatars raided your Sloboda.',
    },
    'uk': {
      'koshoviyPohid': 'Кошовий похід на татар.',
      'tartarRaid': 'Татари напали на нашу Слободу.',
    }
  };
}

class SlobodaLocalizations {
  static List supportedLanguageCodes = ['uk', 'en'];

  static ResourceBuildingsLocalizations resourceBuildingsLocalizations =
      ResourceBuildingsLocalizations();

  static ResourceLocalizations resourceLocalizations = ResourceLocalizations();

  static CityBuildingLocalizations cityBuildingLocalizations = CityBuildingLocalizations();

  static NatureResourceBuildingsLocalizations natureResourceLocalizations = NatureResourceBuildingsLocalizations();

  static Locale locale = Locale(getDefaultOrUrlLanguage());

  static getForKey(String key) {
    final split = key.split('.');
    if (split.length > 1) {
      switch (split[0]) {
        case 'resourceBuildings':
          return resourceBuildingsLocalizations[split[1]];
        case 'resources':
          return resourceLocalizations[split[1]];
        case 'natureResources': return natureResourceLocalizations[split[1]];
        case 'cityBuildings': return cityBuildingLocalizations[split[1]];
        default:
          return key;
      }
    } else {
      return _localizedValues[locale.languageCode][split[0]];
    }
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'overview': 'Overview',
      'events': 'Events',
      'resourceBuildings': 'Resource Buildings',
      'cityBuildings': 'Town Buildings',
      'stock': 'Stock',
      'requiredForProductionBy': 'Required for production by',
      'requiredToBuildBy': 'Required for building',
      'output': 'Output',
      'input': 'Input',
      'build': 'Build',
      'makeTurn': 'Turn',
      'maxNumberOfWorkers': 'Max number of workers',
      'notOccupiedCitizens': 'Free citizens',
      'summer': 'Summer',
      'winter': 'Winter',
      'spring': 'Spring',
      'autumn': 'Autumn',
      'nothingHappened': 'Nothing happened',
      'assignedWorkers': 'Assigned workers',
      'destroyBuilding': 'Destroy Building',
    },
    'uk': {
      'overview': 'Головна',
      'events': 'Події',
      'resourceBuildings': 'Ресурсні будівлі',
      'cityBuildings': 'Міські будівлі',
      'stock': 'Склад',
      'requiredForProductionBy': 'Потребується у виробництві',
      'requiredToBuildBy': 'Потребується для будування',
      'output': 'Виробляє',
      'input': 'Потребує',
      'build': 'Побудувати',
      'makeTurn': 'Хід',
      'maxNumberOfWorkers': 'Вміщує робочих',
      'notOccupiedCitizens': 'Вільні робочі',
      'summer': 'Літо',
      'winter': 'Зима',
      'spring': 'Весна',
      'autumn': 'Осінь',
      'nothingHappened': 'Нічого не відбулося',
      'assignedWorkers': 'Працівники',
      'destroyBuilding': 'Зруйнувати будівлю',
    }
  };

  static String get overview {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['overview'];
  }

  static String get resourceBuildings {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['resourceBuildings'];
  }

  static String get cityBuildings {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['cityBuildings'];
  }

  static String get events {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]['events'];
  }

  static String get stock {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]['stock'];
  }

  static String get requiredForProductionBy {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['requiredForProductionBy'];
  }

  static String get requiredToBuildBy {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['requiredToBuildBy'];
  }

  static String get output {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]['output'];
  }

  static String get input {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]['input'];
  }

  static String get build {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]['build'];
  }

  static String get makeTurn {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['makeTurn'];
  }

  static String get maxNumberOfWorkers {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['maxNumberOfWorkers'];
  }

  static String get notOccupiedCitizens {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['notOccupiedCitizens'];
  }

  static String get nothingHappened {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['nothingHappened'];
  }

  static String get assignedWorkers {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
    ['assignedWorkers'];
  }

  static String get destroyBuilding {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
    ['destroyBuilding'];
  }
}
