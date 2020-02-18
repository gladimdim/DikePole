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
      'koshoviyPohid':
          'Quick raid to tartar lands. You have a chance to get glory, money and resources.',
      'koshoviyPohidQuestion':
          'Messenger from Sich: Koshoviy prepares for the huge raid into the Crimea. He asks whether you want to join. Glory and resources await you!',
      'koshoviyPohidYes':
          'You decided to join the Koshoviy raid into the Crimea. The cossacks dispatched. Let\'s wait on their return!',
      'koshoviyPohidNo':
          'You decided not to participate in Koshoviy raid into the Crimea. The cossacks stayed home and continued on their duties.',
      'tartarRaid': 'Tatars raided your Sloboda.',
      'successTartarRaid':
          'Tartar raid was a big failure for them. You managed to kill their warriors. Enjoy your loot!',
      'failureTartarRaid':
          'Tartars did a great raid on your lands. Couple Slobodas were burnt, people enslaved. Next time prepare for them.',
      'successKoshoviyPohid':
          'Your raid to the Tartars Lands was successful. Enjoy your loot!',
      'failureKoshoviyPohid':
          'Your raid to the Tartars Lands failed. You lost some resources.',
      'saranaInvasion': 'Locust invasion.',
      'successSaranaInvasion':
          'Locust invaded your lands. The grain is destroyed, you lost some food and horses.',
      'failureSaranaInvasion':
          'Locust invaded nearby lands. You were lucky the wind blew to the east. You can continue doing your own business.',
      'childrenPopulation':
          'Happy news came from your settlement! A lot of kids were born this spring and they are all healthy and ready to protect you!',
      'successSteppeFire':
          'The Tatars set fire to the steppe. You threw all your might to save the cattle and the harvest. But this time the element turned out to be stronger than your best. The fire reached the village and you lost grain, horses, wood and a bit of gunpowder.',
      'failureSteppeFire':
          'The Tatars set fire to the steppe. You threw all your might to save the cattle and the harvest. In time to set fire to the steppe on the other side, you have removed the threat from your village. For that, you hunted the exiled game and caught several wild horses that were hiding from the fire near your settlement.',
      'runnersFromSuppresion':
          'In the occupied part of Ukraine peasant performances took place again in order to overthrow the Poles\' yoke. After a few weeks, the Poles defeated the rebels and began to persecute the Ukrainians even more strongly. Fugitives with your own property have come to you on free lands. Now your village is getting stronger. Get ready to avenge your hurt!',
      'settlersArrived': 'A group of migrants from the north came to you. They fled from the lords throughout the village. Considering that your village is already well known and has a church, they have decided to join you. They took everything they needed with you. Now your Sloboda has become even stronger.',
      'guestsFromSich': 'With the first snow cossacks from Sich arrived at your Sloboda. Your village is quite famous amongst the Sich, so they decided to spend the winter with you. They brought great gifts with them.',
    },
    'uk': {
      'koshoviyPohid':
          'Прийміть участь у Кошовому похіді на татар. У вас є шанс здобути славу, гроші та інші ресурси.',
      'koshoviyPohidQuestion':
          'Вістка з Січі: кошовий готується до походу на Крим. Запрошує всіх охочих до слави й багатства.',
      'koshoviyPohidYes':
          'Ви вирішили приєднатися до Кошового походу в Крим! Попрощавшись з козаками, ви стали чекати на їх повернення.',
      'koshoviyPohidNo':
          'Ви вирішили не приєднуватися до Кошового походу в Крим. Козаки залишились вдома займатися господарством.',
      'tartarRaid': 'Татари напали на нашу Слободу.',
      'successTartarRaid':
          'Татари здійснили на вас успішний набіг. Сусідні слободи попалено, людей забрано у рабство. Наступного разу готуйтесь до нього.',
      'failureTartarRaid':
          'Ваші сили вчасно помітили татар в степу і підготувались до відсічі. Декількох татар застрелено, інші покидали речі і втіклі. Молодець!',
      'successKoshoviyPohid':
          'Ви чудово сходили на татар. Застали їз зненацька і без всякого супротиву попалили їм курені, набравши добра. Вітаємо!',
      'failureKoshoviyPohid':
          'Ваш рейд на татар зазнав поразки. Кіш було розбито. Ви втратили ресурси.',
      'saranaInvasion': 'Нашестя сарани.',
      'successSaranaInvasion':
          'Сарана налетіла на ваші угіддя. Поїла поля. Тепер вам і вашим коням немає чого їсти. Ви втратили їжу і декілька коней.',
      'failureSaranaInvasion':
          'Сарана пролетіла на горизонті. Вам пощастило, що вітер дув на схід. Тепер ви можете продовжити займатися своїми справами.',
      'childrenPopulation':
          'Щаслива звістка з вашого селища. Народилося багато дітей. Всі вони здорові і готові швидко рости, щоб стати у стрій з дорослими до оборони рідного краю.',
      'successSteppeFire':
          'Татари підпалили степ. Ви кинули усі сили, щоб врятувати худобу і урожай. Але стихія в цей раз виявилася сильнішою за ваші потуги. Вогонь дійшов до селища і ви втратили збіжжя, коней, деревину та трохи пороху.',
      'failureSteppeFire':
          'Татари підпалили степ. Ви кинули усі сили, щоб врятувати худобу і урожай. Вчасно підпаливши степ з іншої сторони, ви відвели загрозу від вашого селища. За те ви вполювали вигнану дичину і спіймали декілька диких коней, які ховалися від вогню біля вашого поселення.',
      'runnersFromSuppresion':
          'На окупованій частині України знову відбулися селянські виступи з метою скинути ярмо поляків. Після декількох тижнів поляки розбили повстанців і почали ще сильніші гоніння на українців. До вас, на вільні землі, прийшли утікачі з власним майном. Тепер ваше селище стає ще сильнішим. Готуйтеся помститися за кривду!',
      'settlersArrived': 'До вас прийшла група переселенців з півночі. Вони втікли від панів всім селом. Враховуючи, що ваше селище доволі відоме уже та має церкву, вони вирішили приєднатися до вас. З собою вони взяли все необхідне. Тепер ваша Слобода стала ще сильнішою.',
      'guestsFromSich': 'З першим снігом до вас прийшли запорожці на зимівлю. Ваше селище доволі відоме серед січовиків. То ж вони вирішили у вас перебути зиму. З собою козаки принесли вам подарунки. Готуйтеся до літніх боїв.',
    }
  };
}

class SlobodaLocalizations {
  static List supportedLanguageCodes = ['uk', 'en'];

  static ResourceBuildingsLocalizations resourceBuildingsLocalizations =
      ResourceBuildingsLocalizations();

  static ResourceLocalizations resourceLocalizations = ResourceLocalizations();

  static CityBuildingLocalizations cityBuildingLocalizations =
      CityBuildingLocalizations();

  static NatureResourceBuildingsLocalizations natureResourceLocalizations =
      NatureResourceBuildingsLocalizations();

  static RandomEventLocalizations randomEventLocalizations =
      RandomEventLocalizations();

  static Locale locale = Locale(getDefaultOrUrlLanguage());

  static getForKey(String key) {
    final split = key.split('.');
    if (split.length > 1) {
      switch (split[0]) {
        case 'resourceBuildings':
          return resourceBuildingsLocalizations[split[1]];
        case 'resources':
          return resourceLocalizations[split[1]];
        case 'natureResources':
          return natureResourceLocalizations[split[1]];
        case 'cityBuildings':
          return cityBuildingLocalizations[split[1]];
        case 'randomTurnEvent':
          return randomEventLocalizations[split[1]];
        default:
          return key;
      }
    } else {
      final translatedValue = _localizedValues[locale.languageCode][split[0]];
      return translatedValue != null ? translatedValue : split[0];
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
      'yesToRandomEvent': 'Yes, join event.',
      'noToRandomEvent': 'No, leave me alone',
      'addWorker': 'Add worker',
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
      'yesToRandomEvent': 'Так, приєднатися до події.',
      'noToRandomEvent': 'Ні, в цей раз пропущу.',
      'addWorker': 'Додати робітника',
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

  static String get yesToRandomEvent {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['yesToRandomEvent'];
  }

  static String get noToRandomEvent {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['noToRandomEvent'];
  }

  static String get addWorker {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
    ['addWorker'];
  }
}
