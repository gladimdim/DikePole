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

class SlobodaLocalizations {
  static List supportedLanguageCodes = ['uk', 'en'];

  static Locale locale = Locale(getDefaultOrUrlLanguage());

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'overview': 'Overview',
      'events': 'Events',
      'resourceBuildings': 'Resource Buildings',
      'cityBuildings': 'Town Buildings',
    },
    'uk': {
      'overview': 'Головна',
      'events': 'Події',
      'resourceBuildings': 'Ресурсні будівлі',
      'cityBuildings': 'Міські будівлі',
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
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
    ['events'];
  }
}
