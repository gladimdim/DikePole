import 'dart:core';

import 'package:flutter/material.dart';
import 'package:sloboda/loaders/url_parser.dart';
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
      'settlersArrived':
          'A group of migrants from the north came to you. They fled from the lords throughout the village. Considering that your village is already well known and has a church, they have decided to join you. They took everything they needed with you. Now your Sloboda has become even stronger.',
      'guestsFromSich':
          'With the first snow cossacks from Sich arrived at your Sloboda. Your village is quite famous amongst the Sich, so they decided to spend the winter with you. They brought great gifts with them.',
      'successChambulCapture':
          'Your Cossacks spotted the Tatars\' chambul. Seeing that they were few, they attacked them. After a short skirmish, the Tatars fled. Horses aref now yours.',
      'failureChambulCapture':
          'Your Cossacks spotted the Tatars\' chambul. Before the attack, another group came to the Tatars. Your Cossacks did not dare to fight and left.',
      'merchantVisit':
          'A merchant came to visit you on the trip from the Crimea to Lithuania. He bought fur and fish from you. After resting for a week, the merchant headed further to Kyiv.',
      'uniteWithNeighbours':
          'Your efforts have given fruites. Due to the fact that your village is quite successful, has a church and can defend itself against the Tatars, the Cossacks from a nearby winter camp decided to move to you.',
      'successHelpNeighbours':
          'Your squad, after a quick march, entered the battle at the most important moment. The defenders heard the shots and made a desperate outing outside the stockade. The Tatars were thus attacked from two sides and quickly escaped. After the fight the Head of the Sloboda could not hold back tears. Thanks to your settlement, one hundred orthodox souls were saved. In gratitude, the settlers gave you money. The glory of your Sloboda got even louder!',
      'failureHelpNeighbours':
          'Your squad didn\'t have enough hours to help the neighbors. The Tatars tore the palisade and began to plunder the settlement. When they saw your squad, they threw a yasser and fled with resources only. Scattering all the enemies around, the detachment entered the burned village. The Cossack corpse lay everywhere. The Tatars spared no one: old men, women, children. All lay in puddles of blood. The village is completely destroyed. Five surviving families have collected the remains of your belongings and together with your detachment have gone to your Sloboda. Your Cossacks have buried their dead and strangers and have gone back. Time for revenge soon.',
      'HelpNeighboursQuestion':
          'Alarm! Your scouts picked up a wounded Cossack, who reported the terrible news: a Tatar detachment suddenly came upon a nearby settlement. All the Cossacks were in the fields, so few people became defensive. Time goes by for hours to see if the settlement can withstand. Will you help your neighbors?',
      'HelpNeighbours':
          'Decide whether to help neighbors repel the Tatar invasion.',
      'HelpNeighboursYes':
          'When you hit the trumpets, you gathered all the Cossacks and immediately marched. All the inhabitants of the settlement closed behind the palisade. From small to large they poured into the ditch and said goodbye to the Cossacks who lit the steppe.',
      'HelpNeighboursNo':
          'After thinking, you decided to save your people. The neighbors are too late to help.',
      'successBuyPrisoners':
          'Your ambassadors successfully negotiated with the Tatars and bought five prisoners. They all returned back to the settlement.',
      'failureBuyPrisoners':
          'As a result of misunderstanding, the Tatars treated your detachment hostile and attacked you. Fortunately, during the pursuit of your Cossacks in the steppe, you saw another journey. By joining forces, you have broken the Tatars\' squad. They returned to their camp and released all prisoners. Everybody in Loca Deserta will remember this tale when greedy tartars lost everything.',
      'BuyPrisonersYes':
          'You ordered a small squad of negotiators to be sent out. There is a chance to buy the prisoners cheaper than in the Crimea without intermediaries.',
      'BuyPrisonersNo':
          'This may be a trap, you decide not to send ambassadors to negotiate.',
      'BuyPrisoners': 'Buy captives from captivity.',
      'BuyPrisonersQuestion':
          'You have learned that there are Tatars with Ukrainian prisoners nearby. You can try buying them from slavery. This is a dangerous thing, as Tatars can attack you.',
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
          'Похід на татар був вдалим. Застали їх зненацька і без всякого супротиву попалили їм курені, набравши добра. Вітаємо!',
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
          'Татари підпалили степ. Ви кинули усі сили, щоб врятувати худобу і урожай. Вчасно підпаливши степ з іншої сторони, ви відвели загрозу від вашого селища. Одночасно ви вполювали вигнану дичину і спіймали декілька диких коней, які ховалися від вогню біля вашого поселення.',
      'runnersFromSuppresion':
          'На окупованій частині України знову відбулися селянські виступи з метою скинути ярмо поляків. Після декількох тижнів поляки розбили повстанців і почали ще сильніші гоніння на українців. До вас, на вільні землі, прийшли утікачі з власним майном. Тепер ваше селище стає ще сильнішим. Готуйтеся помститися за кривду!',
      'settlersArrived':
          'До вас прийшла група переселенців з півночі. Вони втікли від панів всім селом. Враховуючи, що ваше селище доволі відоме уже та має церкву, вони вирішили приєднатися до вас. З собою вони взяли все необхідне. Тепер ваша Слобода стала ще сильнішою.',
      'guestsFromSich':
          'З першим снігом до вас прийшли запорожці на зимівлю. Ваше селище доволі відоме серед січовиків. То ж вони вирішили у вас перебути зиму. З собою козаки принесли вам подарунки. Готуйтеся до літніх боїв.',
      'successChambulCapture':
          'Ваші козаки помітили чамбул татар. Упевнившись, що їх було мало, вони напали на них. Після короткої сутички татари утікли. Чамбул коней тепер ваш.',
      'failureChambulCapture':
          'Ваші козаки помітили чамбул татар. Перед самою атакою до татар підійшла ще одна група. Ваші козаки не наважилися вступати у сутичку і відійшли.',
      'merchantVisit':
          'По дорозі з Криму в Литву до вас завітав торговець. Він викупив у вас хутра й рибу. Відпочивши тиждень, торговець попрямував далі в Київ.',
      'uniteWithNeighbours':
          'Ваші потуги далися взнаки. Через те, що ваше селище доволі успішне, має церкву і може боронитися від татар, козаки з сусіднього зимовника вирішили переселитися до вас',
      'successHelpNeighbours':
          'Ваш загін після швидкого маршу вступив у бій в самий важливий момент. Оборонці почули постріли й зробили відчайдушну вилазку за межі частоколу. Таким чином татари були атаковані з двох сторін та швидко прийнялися втікати назад. Після бою староста не міг стримати сліз. Завдяки вашій слободі сто православних душ було врятовано. В знак подяки слободяне подарували вам гроші. Слава про вашу Слободу стала ще гучнішою!',
      'failureHelpNeighbours':
          'Ваш загін не встиг всього декілька годин, щоб допомогти сусідам. Татари роздерли частокол та почали грабувати селище. Побачивши ваш загін, вони кинули ясир й втікли лише з ресурсами. Розсіявши всі чамбули навколо, загін зайшов в спалене селище. Скрізь лежав труп козака. Татари не пощадили нікого: старі, жінки, діти. Всі лежали забиті в калюжах крові. Селище повністю зруйноване. П\'ять уцілілих сімей зібрали залишики речей та разом з вашим загоном вирушили до вашої Слободи. Ваші козаки поховали своїх й чужих загиблих та вирушили назад. Час помсти незабаром.',
      'HelpNeighboursQuestion':
          'Тривога! Ваші роз\'їзди підібрали пораненого козака, який сповістив страшну новину: чамбул татар наскочив зненацька на сусідню слободу. Всі козаки були в полях, тому до оборони стало мало людей. Час іде на години, чи зможе слобода вистояти. Ви допоможете своїм сусідам?',
      'HelpNeighbours': 'Вирішуйте, чи допомогти сусідам відбити навалу татар.',
      'HelpNeighboursYes':
          'Ударивши в сурми, ви зібрали всіх козаків і негайно виступили до маршу. Всі жителі слободи закрилися за частоколом. Від малу до велика висипали на рів та прощалися з козаками, які закурили степ.',
      'HelpNeighboursNo':
          'Поміркувавши, ви вирішили зберегти своїх людей. Сусідам уже піздно допомогати.',
      'successBuyPrisoners':
          'Ваші посли успішно провели перемовини з татарами та викупили п\'ять бранців. Всі разом повернулися назад в слободу.',
      'failureBuyPrisoners':
          'В результаті непорозуміння татари віднеслись до вашого загону вороже і атакували вас. На щастя, під час переслідування ваших козаків в степу вас побачив інший роз\'їзд. Об\'єднавши зусилля, ви розбили чамбул татар. Повернулись до їх табору й звільнили всіх бранців. Про цю оказію життя будуть ще довго згадувати з посмішкою всі козаки. Як татари погнались за слободянами, а знайшли свою смерть.',
      'BuyPrisonersYes':
          'Ви наказали вислалити невеликий загін слободян для перемовин. Є шанс викупити бранців дешевше ніж в Криму без посередників.',
      'BuyPrisonersNo':
          'Це може бути пасткою, ви вирішили не висилати послів для перемовин.',
      'BuyPrisoners': 'Викупіти бранців з полону.',
      'BuyPrisonersQuestion':
          'Вам стало відомо, що недалеко стоїть чамбул татар з бранцями. Ви можете спробувати викупити їх. Справа ця небезпечна, так як татари можуть напасти на вас.',
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
      'hasNoAssignedWorkers': 'has no assigned workers.',
      'glory': 'Glory',
      'faith': 'Faith',
      'citizens': 'Citizens',
      'defense': 'Defense level',
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
      'hasNoAssignedWorkers': 'не має призначених робітників.',
      'glory': 'Слава',
      'faith': 'Віра',
      'citizens': 'Козаки',
      'defense': 'Рівень захисту',
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

  static String get hasNoAssignedWorkers {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['hasNoAssignedWorkers'];
  }

  static String get glory {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]['glory'];
  }

  static String get faith {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]['faith'];
  }

  static String get defense {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['defense'];
  }

  static String get citizens {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['citizens'];
  }
}
