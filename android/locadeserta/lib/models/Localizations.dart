import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

var version = "1.63";

class LDLocalizations {
  LDLocalizations(this.locale);

  final Locale locale;

  static LDLocalizations of(BuildContext context) {
    return Localizations.of<LDLocalizations>(context, LDLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'continue': 'Continue',
      'signout': 'Signout',
      'next': 'Next',
      'signinwithgoogle': "With Google",
      'apptitle': 'Loca Deserta',
      'availablestories': 'Available stories',
      'youhavesavedgame': 'You have a saved game',
      'bookcatalog': 'Catalog of books',
      'view': 'View',
      'start': 'Start',
      'greet': 'Good day',
      'version': 'Version',
      'loadingstory': 'Loading Story',
      'startstory': 'Read',
      'lookingforheroes': 'Looking for heroes in Loca Deserta lands...',
      'save': 'Save',
      'reset': 'Reset',
      'anonlogin': 'Guest',
      'welcometext': 'Select login method',
    },
    'uk': {
      'continue': 'Продовжити',
      'signout': 'Вийти',
      'next': 'Далі',
      'signinwithgoogle': "З Google",
      'apptitle': 'Дике Поле',
      'availablestories': 'Доступні історії',
      'youhavesavedgame': 'У вас є збережена гра',
      'bookcatalog': ' Каталог книжок',
      'view': 'Переглянути',
      'start': 'Почати',
      'greet': 'Добрий день',
      'version': 'Версія',
      'loadingstory': 'Завантаження історії',
      'startstory': 'Читати',
      'lookingforheroes': 'Шукаємо героїв в землях Дикого Поля...',
      'save': 'Зберегти',
      'reset': 'Заново',
      'anonlogin': 'Гість',
      'welcometext': 'Виберіть метод входу в гру'
    },
    'pl': {
      'continue': 'Dalej',
      'signout': 'Wyloguj się',
      'next': 'Kolejny',
      'signinwithgoogle': "Z google",
      'apptitle': 'Dzikie Pole',
      'availablestories': 'Dostępne historie',
      'youhavesavedgame': 'Masz zapisaną grę',
      'bookcatalog': 'Katalog książek',
      'view': 'Widok',
      'start': 'Początek',
      'greet': 'Dobry dzień',
      'version': 'Wersja',
      'loadingstory': 'Historia ładowania',
      'startstory': 'Сzytać',
      'lookingforheroes': 'poszukuje bohaterów w Dzikie Pole ziemia...',
      'save': 'Zapisać',
      'reset': 'Nastawić',
      'anonlogin': 'Gość',
      'welcometext': 'Wybierz metodę logowania',
    }
  };

  String get Continue {
    return _localizedValues[locale.languageCode]['continue'];
  }

  String get signInWithGoogle {
    return _localizedValues[locale.languageCode]['signinwithgoogle'];
  }

  String get signOut {
    return _localizedValues[locale.languageCode]['signout'];
  }

  String get next {
    return _localizedValues[locale.languageCode]['next'];
  }

  String get appTitle {
    return _localizedValues[locale.languageCode]['apptitle'];
  }

  String get availableStories {
    return _localizedValues[locale.languageCode]['availablestories'];
  }

  String get youHaveSavedGame {
    return _localizedValues[locale.languageCode]['youhavesavedgame'];
  }

  String get bookCatalog {
    return _localizedValues[locale.languageCode]['bookcatalog'];
  }

  String get view {
    return _localizedValues[locale.languageCode]['view'];
  }

  String get start {
    return _localizedValues[locale.languageCode]['start'];
  }

  String greetUserByName(String name) {
    return '${_localizedValues[locale.languageCode]['greet']}, $name';
  }
  String get versionLabel {
    return "${_localizedValues[locale.languageCode]['version']}: $version";
  }

  String get loadingStory {
    return _localizedValues[locale.languageCode]['loadingstory'];
  }

  String get startStory {
    return _localizedValues[locale.languageCode]['startstory'];
  }

  String get lookingForHeroes {
    return _localizedValues[locale.languageCode]['lookingforheroes'];
  }

  String get save {
    return _localizedValues[locale.languageCode]['save'];
  }
  String get reset {
    return _localizedValues[locale.languageCode]['reset'];
  }
  String get anonLogin {
    return _localizedValues[locale.languageCode]['anonlogin'];
  }
  String get welcomeText {
    return _localizedValues[locale.languageCode]['welcometext'];
  }

}

class LDLocalizationsDelegate extends LocalizationsDelegate<LDLocalizations> {
  const LDLocalizationsDelegate();

  bool isSupported(Locale locale) =>
      ['en', 'uk', 'pl'].contains(locale.languageCode);

  Future<LDLocalizations> load(Locale locale) {
    return SynchronousFuture<LDLocalizations>(LDLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<LDLocalizations> old) {
    return false;
  }
}
