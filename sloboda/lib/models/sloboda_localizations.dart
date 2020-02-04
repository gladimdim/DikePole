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
    return 'uk';
  }
}

class ResourceLocalizations {
  static Map<String, Map<String, String>> _localizedMap = {
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

  String operator [](String key) {
    final lang =
    _localizedMap[SlobodaLocalizations.locale.languageCode];

    if (lang.containsKey(key)) {
      return lang[key];
    } else {
      return key;
    }
  }
}

class ResourceBuildingsLocalizations {
  static Map<String, Map<String, String>> _localizedMap = {
    'en': {
      'mill': 'Mill',
      'field': 'Field',
      'quarry': 'Quarry',
      'smith': 'Smith',
      'stables': 'Stables',
      'ironMine': 'Iron Mine',
      'trapperCabin': 'Trapper\'s Cabin',
    },
    'uk': {
      'mill': 'Млин',
      'field': 'Поле',
      'quarry': 'Каменярня',
      'smith': 'Кузня',
      'stables': 'Конюшня',
      'ironMine': 'Рудня',
      'trapperCabin': 'Хата уходника',
    }
  };

  String operator [](String key) {
    final lang =
    _localizedMap[SlobodaLocalizations.locale.languageCode];

    if (lang.containsKey(key)) {
      return lang[key];
    } else {
      return key;
    }
  }
}

class SlobodaLocalizations {
  static List supportedLanguageCodes = ['uk', 'en'];

  static ResourceBuildingsLocalizations resourceBuildingsLocalizations =
      ResourceBuildingsLocalizations();

  static ResourceLocalizations resourceLocalizations = ResourceLocalizations();

  static Locale locale = Locale(getDefaultOrUrlLanguage());

  static getForKey(String key) {
    final split = key.split('.');
    switch (split[0]) {
      case 'resourceBuildings': return resourceBuildingsLocalizations[split[1]];
      case 'resources': return resourceLocalizations[split[1]];
      default: return key;
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
      'makeTurn': 'Make Turn',
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
      'makeTurn': 'Закінчити сезон',
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
}
