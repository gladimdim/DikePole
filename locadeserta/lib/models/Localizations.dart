import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

var version = "1.69";

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
      'theend': 'THE END',
      'tobecontinued': 'To be continued. Wait on the story update.',
      'showstorydetails': 'More Details',
      'translationnotready': 'Translations are not yet ready for your language.',
      'storysaved': 'Story saved',
      'storynotsaved': 'Story not saved',
    },
    'uk': {
      'continue': 'Продовжити',
      'signout': 'Вийти',
      'next': 'Далі',
      'signinwithgoogle': "З Google",
      'apptitle': 'Дике Поле',
      'view': 'Переглянути',
      'start': 'Почати',
      'greet': 'Доброго дня',
      'version': 'Версія',
      'loadingstory': 'Завантаження історії',
      'startstory': 'Читати',
      'lookingforheroes': 'Шукаємо героїв в землях Дикого Поля...',
      'save': 'Зберегти',
      'reset': 'Заново',
      'anonlogin': 'Гість',
      'welcometext': 'Виберіть метод входу в гру',
      'theend': "Кінець",
      'tobecontinued': 'Далі буде. Чекайте на оновлення.',
      'showstorydetails': 'Детальніше',
      'translationnotready': 'Переклад історії на вашу мову ще не готовий.',
      'storysaved': 'Гру збережено',
      'storynotsaved': 'Гру не було збережено'
    },
    'pl': {
      'continue': 'Dalej',
      'signout': 'Wyloguj się',
      'next': 'Kolejny',
      'signinwithgoogle': "Z google",
      'apptitle': 'Dzikie Pole',
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
      'theend': 'Koniec',
      'tobecontinued': 'Ciąg dalszy nastąpi. Poczekaj na aktualizację historii',
      'showstorydetails': 'Więcej szczegółów',
      'translationnotready': 'Tłumaczenie opowiadań dla twojego języka nie jest jeszcze gotowe.',
      'storysaved': 'Gra jest zapisana',
      'storynotsaved': 'Gra nie została zapisana',
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
  String get theEnd {
    return _localizedValues[locale.languageCode]['theend'];
  }
  String get toBeContinued {
    return _localizedValues[locale.languageCode]['tobecontinued'];
  }
  String get showStoryDetails {
    return _localizedValues[locale.languageCode]['showstorydetails'];
  }
  String get translationNotYetReady {
    return _localizedValues[locale.languageCode]['translationnotready'];
  }
  String get storySaved {
    return _localizedValues[locale.languageCode]['storysaved'];
  }
  String get storyNotSaved {
    return _localizedValues[locale.languageCode]['storyNotSaved'];
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
