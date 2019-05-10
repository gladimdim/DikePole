import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

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
      'signinwithgoogle': "Sign in with Google",
      'apptitle': 'Loca Deserta',
      'availablestories': 'Available stories',
      'youhavesavedgame': 'You have a saved game',
    },
    'uk': {
      'continue': 'Продовжити',
      'signout': 'Вийти',
      'next': 'Далі',
      'signinwithgoogle': "Зайти з Google",
      'apptitle': 'Дике Поле',
      'availablestories': 'Доступні історії',
      'youhavesavedgame': 'У вас є збережена гра',
    },
    'pl': {
      'continue': 'Dalej',
      'signout': 'Wyloguj się',
      'next': 'Kolejny',
      'signinwithgoogle': "zaloguj się za pomocą Google",
      'apptitle': 'Dzikie Pole',
      'availablestories': 'Dostępne historie',
      'youhavesavedgame': 'Masz zapisaną grę',
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
