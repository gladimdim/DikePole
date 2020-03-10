import 'dart:core';

import 'package:flutter/material.dart';
import 'package:sloboda/loaders/url_parser.dart';
import 'package:sloboda/models/app_preferences.dart';

var version = "0.010";

String getDefaultOrUrlLanguage() {
  var urlLang = UrlParser.getLanguage();
  var savedLangCode;
  try {
    savedLangCode = AppPreferences.instance.getUILanguage();
  } catch (e) {
    savedLangCode = 'uk';
  }
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

class CityPropsLocalizations extends InternalLocalizations {
  Map<String, Map<String, String>> _localizedMap = {
    'en': {
      'faith': 'Faith',
      'faithDescription':
          'Faith influences chance of getting certain random events. Produced by the Church. Wins in battles versus impure also raises the Faith. The central Metripolian of Orthodox Church in Kyiv might give you tasks, if your Faith is high.',
      'glory': 'Glory',
      'gloryDescription':
          'Glory influences chance of getting certain military random events. Even nearby Slobodas might join your forces and unite with you. The higher the Glory, the more known your settlement is. This means epic events might occur. Can be increased only by participating in events.',
      'defense': 'Defense',
      'defenseLevel':
          'Defense. Decreases chances for tartar raids. Can lower the level of damage done by enemy forces. Can be increased by City Defense Buildings.',
      'citizens': 'Citizens',
      'citizensDescription':
          'Citizens. The moving part of the settlement. They do the work. Can be trained to be the Cossack. They can be killed or taken as prisoners. The Resource Buildings require citizens to be assigned to them in order to produce.',
      'cossacks': 'Cossack',
      'cossackDescription':
          'Cossacks. The defenders of Ukrainian lands. Use Shooting range to train a citizen to become a Cossack. Only cossacks can take part in military events, raids and defending the Settlement. Cannot be converted back to citizen.',
    },
    'uk': {
      'faithDescription':
          'Віра впливає на появу певних подій. Підвищується Церквою, а також різними подіями, наприклад у боях з нехристями або під час захисту українських земель. Без Церкви і високої Віри до вас не будуть приходити біженці з окупованих земель. Метрополит Київський може давати вам спеціальні завдання, якщо ваша Віра доволі висока.',
      'gloryDescription':
          'Слава здобувається в боях з ворогом. Впливає на вірогідність подій. Чим вища слава, тим більше епічні події стають доступними. ',
      'defenseDescription':
          'Рівень захисту. Поки що ні на що ни впливає, але зробимо.',
      'citizensDescription':
          'Люди, які живуть у вашій слободі. Працюють на різних ділянках. Можуть стати козаками, якщо їх натренувати на Стрільбищі. Щоб збільшити кількість людей, приймайте участь в різних подіях, збільшуйте показники Слободи, і тоді до вас приєднаються люди. Або ж будуйте курені.',
      'cossacksDescription':
          'Козаки. Беруть участь у військових походах, обороні українських земель. Основна діюча сила будь-якої події. Чим більше козаків, тим більші військові рейди вам стають доступні. Козаки тренуються з людей на Стрільбищі.',
      'faith': 'Віра',
      'glory': 'Слава',
      'defense': 'Рівень захисту',
      'citizens': 'Люди',
      'cossacks': 'Козаки',
    }
  };
}

class CityBuildingLocalizations extends InternalLocalizations {
  Map<String, Map<String, String>> _localizedMap = {
    'en': {
      'house': 'House',
      'wall': 'Wall',
      'tower': 'Tower',
      'watchTower': 'Watch Tower',
      'church': 'Church',
      'shootingRange': 'Shooting Range',
    },
    'uk': {
      'house': 'Курінь',
      'wall': 'Частокол',
      'tower': 'Башта',
      'watchTower': 'Хфігура',
      'church': 'Церква',
      'shootingRange': 'Стрілецький майданчик'
    }
  };
}

class ResourceLocalizations extends InternalLocalizations {
  Map<String, Map<String, String>> _localizedMap = {
    'en': {
      'food': 'Food',
      'foodDescription': 'Used in all productions. Can be produced by Fields.',
      'stone': 'Stone',
      'stoneDescription':
          'Used to build city defenses. Can be produced in Stone mines.',
      'wood': 'Wood',
      'woodDescription':
          'Used to build all buildings. Can be produced in Forest.',
      'ore': 'Ore',
      'oreDescription': 'Used to create firearms. Can be produced in Ore Mine.',
      'money': 'Money',
      'moneyDescription':
          'Used to be sent to the Sich to support defenders of Ukraine. Can be earned in battles, raids or in Mill.',
      'horse': 'Horse',
      'horse':
          'Used to create cossacks. Can be earned in events, raids. Can be produced in Stables.',
      'powder': 'Powder',
      'powderDescription':
          'Used to create firearms. Can be produced in Cellar Powder.',
      'fur': 'Fur',
      'furDescription': 'Used for traiding. Can be produced by Trapper House.',
      'fish': 'Fish',
      'fishDescription': 'Used to trading. Can be produced in River.',
      'firearm': 'Firearm',
      'firearmDescription':
          'Used to create cossacks. Can be produced by Smith.',
    },
    'uk': {
      'food': 'Їжа',
      'foodDeascription':
          'Потребується для всіх виробництв. Може бути здобута в бою або вирощена не полях.',
      'stone': 'Каміння',
      'stoneDescription':
          'Потребується у побудові обороних споруд. Добувається в Каменярні.',
      'wood': 'Дерево',
      'woodDescription': 'Потребується у побудові споруд. Добувається в Лісі.',
      'ore': 'Руда',
      'oreDescription': 'Потребується для самопалів. Добувається в Рудні.',
      'money': 'Гроші',
      'moneyDescription':
          'Їх можна відсилати на Січ для підтримки оборонців України. Можна здобувати в боях, подіях або використовуючи Млини.',
      'horse': 'Коні',
      'horseDescription':
          'Потребується для спорядження козаків. Виробляється в Конюшнях.',
      'powder': 'Порох',
      'powderDescription':
          'Потребується для створення самопалів. Добувається в Пороховому Льоху.',
      'fur': 'Хутра',
      'furDescription':
          'Використовується для торгівлі. Виробляється в Хаті Уходника.',
      'fish': 'Риба',
      'fishDescription': 'Використовується для торгівлі. Добувається в Річці.',
      'firearm': 'Самопал',
      'firearmDescription':
          'Використовується для спорядження козаків. Виробляється в Кузні.',
    }
  };
}

class ResourceBuildingsLocalizations extends InternalLocalizations {
  Map<String, Map<String, String>> _localizedMap = {
    'en': {
      'mill': 'Mill',
      'millDescription': 'Earns you money by consuming food.',
      'field': 'Field',
      'fieldDescription': 'The main food income resource.',
      'quarry': 'Quarry',
      'quarryDescription': 'Produces stone used for building.',
      'smith': 'Smith',
      'smithDescription': 'Produces firearms. Needs ore, powder and food.',
      'stables': 'Stables',
      'stablesDescription':
          'Produces horses. They are used to convert citizens into cossacks.',
      'ironMine': 'Iron Mine',
      'ironMineDescription':
          'Produces iron ore. It is used by the Smith to create firearms for cossacks.',
      'trapperCabin': 'Trapper\'s Cabin',
      'trapperCabinDescription':
          'Hunter goes into the woods and catches the wild animals. Produces furs.',
      'powderCellar': 'Powder Cellar',
      'powderCellarDescription':
          'Produces powder. It is used by the Smith to create firarms for cossacks.',
    },
    'uk': {
      'mill': 'Млин',
      'millDescription':
          'Заробляє вам гроші. Люди приносять сюди збіжжя і платять вам гроші за борошно.',
      'field': 'Поле',
      'fieldDescription': 'Основний виробник їжі для вашого селища.',
      'quarry': 'Каменярня',
      'quarryDescription': 'Виробляє каміння для будівництв.',
      'smith': 'Кузня',
      'smithDescription': 'Виробляє самопали. Потребує залізо.',
      'stables': 'Конюшня',
      'stablesDescription': 'Виробляє коней. Вони необхідні козакам.',
      'ironMine': 'Рудня',
      'ironMineDescription': 'Виробляє залізо для коваля.',
      'trapperCabin': 'Хата уходника',
      'trapperCabinDescription':
          'Уходник ходить в ліс по дичину. Хутра можна продати за гарні кошти в Каневі.',
      'powderCellar': 'Пороховий льох',
      'powderCellarDescription': 'Виробляє порох для виробництва самопалів.'
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
      'successAttackChambul':
          'Your unit detained the Tatars near the Black Tomb. Hiding in the grass, the Cossacks waited for the Tatars to come up and shoot them. The surviving Tatars resisted, but the Cossacks managed to take them to the acran. Running horses were quickly seized in the steppe and led to Sloboda.',
      'failureAttackChambul':
          'The Cossacks wanted to catch the Tatars\' suddenly under the Black Tomb. But the Tatars were ahead of them and ambushed themselves. With their arrows falling, their cavalry attacked from the flank and broke up the detachment. You have lost the good soldiers-defenders of Ukraine. The earth is down to them.',
      'AttackChambulYes':
          'You have ordered to send twenty Cossacks to attack the Tatars. According to scouts, a herd of horses protects a dozen Tatars, they will be easy to deal with. The Cossacks flew to the Black Tomb to ambush.',
      'AttackChambulNo':
          'You were mistrustful of the words of a scout that there seemed to be only ten Tatars guarding a herd of horses. It can be a trap. You decided not to attack the Tatars.',
      'AttackChambul': 'Scouts saw Tatars in the steppe near the Black Tomb.',
      'AttackChambulQuestion':
          'At sunrise a scout reported to you. He saw the Tatars\' squad of ten warriors. They lead the horses to pastures. You have a chance to squeeze them and pick up the horses yourself. Do you want to send your regimenent to take horses from them?',
      'successTrapChambulOnWayBack':
          'The Cossacks caught the Tatars before they all joined the forces. With the first battle, the Cossacks scattered the first great Tatar regimenet, and the next day cut straight to the leg the second part. A large number of prisoners refused to return to the lords and dispersed through the farms and winter camps. Some of the people asked you to go to Sloboda. Fairy tales and stories about your settlement are known even in Podillya.',
      'failureTrapChambulOnWayBack':
          'Not all units had time to join the Cossacks. Having accepted an unequal battle with the Tatars at the crossing, the Cossacks almost overthrew the Tatar army, but at the last moment another squad came to the Tatars and smashed our forces. The losses are very large. Sloboda lost many heroes ...',
      'TrapChambulOnWayBackYes':
          'After consulting with your foreman, you decided to put in a squad all the Cossacks who can hold weapons. Protecting Ukrainian Lands is Above All! Your squad got enough resources and weapons for the big fight. You said goodbye to the hundreds who left in the morning to connect with the Cossacks.',
      'TrapChambulOnWayBackNo':
          'You and the sergeant agreed that a huge chunk of the border with the Tatars cannot be left without defense and the messengers were refused. They understood you and moved to the core forces.',
      'TrapChambulOnWayBack': 'The Tatars\' massive invasion of the Podillia.',
      'TrapChambulOnWayBackQuestion':
          'Two Cossacks rushed from Sich. The Zaporozhian troops became aware of the Tartars\' huge raid on Podillya. They are now returning back to the Crimea with a thousand yasirs and a huge cart of loot. Koshoviy asks everyone who can join the Orthodox army and break up the infidel army on the Black Way. Knowing that your Sloboda is large enough, he counts on your help.',
      'successHelpDefendSich':
          'Your cossacks returned back from defending Sich. The tartars were not seen.',
      'failureHelpDefendSich':
          'Your squad, together with other cossack successfully defended the Sich. Local bandits knew the main force was away and decided to steal horses. After they saw cossacks they quickly retreated',
      'HelpDefendSichYes': 'Give a squad for defending Sich.',
      'HelpDefendSichNo': 'Deny giving cossacks to Sich.',
      'HelpDefendSich': 'Defend Sich while the main forces are away.',
      'HelpDefendSichQuestion':
          'Cossacks from Sich asked you to give you some Cossacks who could defend the Sich during their maritime tour of the Turks. Since your Sloboda is not big yet, you are not being invited for raid.',
      'successAttackPolishLands':
          'The Lyakhs decided to attack the Cossacks from the march, but their cavalry was struck by gunfire behind the carts. Quickly making a flank attack with a cavalry, the Cossacks ended the defeat of the Polish punchers. They got their camp and went back to Ukraine.',
      'failureAttackPolishLands':
          'It was not possible to get the polish forces from the march. Both armies camped and began trench warfare. The resources of the Cossacks ended faster and after negotiations with the Poles, the Cossacks gave them the officers and laid down their weapons. Lyakh did not observe the terms of the contract and severely punished the Cossacks. The Zaporozhye army will not soon gather strength for another such adventure.',
      'AttackPolishLandsYes': 'Issue a big horse squad to help Sichoviki.',
      'AttackPolishLandsNo': 'Deny. Stay on the border with Tartars.',
      'AttackPolishLands': 'Raid the Poland lands',
      'AttackPolishLandsQuestion':
          'The Zaporozhye Cossacks decided to attack polish lands. The magnates have amassed many soldiers to strike a pre-emptive blow at the Ukrainians. Therefore, the Sich calls all the Cossacks to raid the Poland. Since your village has sufficient resources of people and horses, it can join the raid.',
      'successSendMoneyToSchoolInKaniv':
          'You donated money to expand school in Kanev. Now more Cossack children will be able to receive education. A bright mind in children is the future of Ukraine.',
      'SendMoneyToSchoolInKanivYes': 'Donate money for school.',
      'SendMoneyToSchoolInKanivNo': 'Refuse to give money.',
      'SendMoneyToSchoolInKaniv':
          'Donation of money for expanding school in Kanev.',
      'SendMoneyToSchoolInKanivQuestion':
          'You got cossacks as a guests. They ask for donation to enhance the school in Kanev. The lands are becoming more populated and there is no enough space for new pupils.',
      'successSendMerchantToKanev':
          'The squad with goods successfully arrived at Kaniv. They sold all the fish and furs and returned back.',
      'failureSendMerchantToKanev':
          'Your journey was attacked by road bandits. The goods were stolen. Happily, no one was wounded or killed.',
      'SendMerchantToKanevYes':
          'Cossacks loaded all the fish and fur and departed to the Kaniv with the first sun rays.',
      'SendMerchantToKanevNo':
          'You heard there are some bandits in steppe. You decided to keep the goods and try the trade them in next season.',
      'SendMerchantToKanev': 'Send tranding journey to the Kaniv.',
      'SendMerchantToKanevQuestion':
          'You got a lot of fish and fur. You can send a trading journey to the Kaniv and sell the goods. The steppes are not calm, so there is a risk of encountering bandits',
      'successAttackCatholicChurches':
          'At night, hundreds of Cossacks, along with Orthodox priests, entered the church. The Catholics dispatched a group of soldiers, but after a short skirmish, they all ran away. You received their small cart and rich gifts from the Metropolitan. The sacred cause for the return of Ukrainian lands and churches is in full swing.',
      'failureAttackCatholicChurches':
          'Someone warned the plans of the Metropolitan\'s plans. You were met by an armed company of Jesuits. There was a short melee fight. Metropolitan forces were dispersed. You have lost several Cossacks killed.',
      'AttackCatholicChurchesYes':
          'You are pleased to assist the Metropolitan in this holy cause. You sent 20 Cossacks to help him.',
      'AttackCatholicChurchesNo':
          'Your main goal is to defend against the Tatars. Let the priests decide their church affairs themselves.',
      'AttackCatholicChurches': 'Reflect the Orthodox parish from Catholics.',
      'AttackCatholicChurchesQuestion':
          'The more blessed Metropolitan of Kiev, Sylvester Belkevich, asks the Cossack Society to repatriate a parish occupied by Catholics near the Bila Tserkva. He asks with the help of your armed presence to persuade the Polands to return the church back to the possession of the Orthodox metropolis.',
      'successHelpDefendAgainstCatholicRaiders':
          'Early in the morning, Polish mercenaries attempted to incite a crowd to storm Lavra. But the Cossacks used small mobile groups to catch and execute groups paid polish attackers. The perpetrator of the assault hid in St. Andrew\'s Church, but was pulled from there and hung on the descent to Podil. The St. Andrew\'s Church was immediately seized by armed Cossacks and introduced Orthodox priests there. The counter operation was so successful that the Metropolitan offered you a whole treasure of money and things in gratitude for the protection of the Orthodox faith.',
      'failureHelpDefendAgainstCatholicRaiders':
          'They were terrified by the strength that came to support Lavra. Hired bandits among the local ran away, and the armed reapers were afraid to join you in the battle. The Metropolitan in gratitude gave you rich gifts. ',
      'HelpDefendAgainstCatholicRaidersYes':
          'The Jesuit plague must be stopped. You are pleased to assist the Metropolitan in this holy cause. You sent 50 armed Cossacks to help him.',
      'HelpDefendAgainstCatholicRaidersNo':
          'Your main goal is to defend against the Tatars. Let the priests decide their church affairs themselves.',
      'HelpDefendAgainstCatholicRaiders': 'Protect the Kyiv-Pechersk Lavra.',
      'HelpDefendAgainstCatholicRaidersQuestion':
          'Blessed Metropolitan of Kiev Sylvester Belkevich sent messengers to Free Lands. He learned that the polish troopers, along with the Jesuits, were preparing an armed attack to capture the Kyivv-Pechersk Lavra. He requests the deployment of armed Cossacks near Kyiv to help repel the attack.',
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
          'Татари здійснили на вас успішний набіг. Сусідні слободи попалено, людей забрано у рабство. Частина людей встигла закритись за укріпленням. Наступного разу готуйтесь до нього.',
      'failureTartarRaid':
          'На сході сонця на вас раптово напали татари. Ваші розвідники вчасно помітили татар в степу і підготувались до відсічі. Декількох татар застрелено, інші покидали речі і втіклі. Молодець!',
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
      'successAttackChambul':
          'Ваш загін підстеріг татар біля Чорної Могили. Заховавшись в траві, козаки почекали, коли татари підійдуть впритул і розстріляли їх. Уцілілі татари чинили опір, але козакам вдалося взяти їх на аркан. Коней, які розбіглись, швидко схопили в степу і повели до Слободи.',
      'failureAttackChambul':
          'Козаки хотіли застати зненацька чамбул татар під Чорною Могилою. Але татари випередили їх і самі влаштували засідку. Засипавши козаків стрілами, їхня кіннота атакувала з флангу і розбила загін. Ви втратили гарних воїнів-захисників України. Земля їм пухом.',
      'AttackChambulYes':
          'Ви розпорядилися вислати двадцять козаків для атакування чамбула татар. Зі слів розвідників, табун коней охороняє десяток татар, з ними буде легко справитися. Козаки полетіли до Чорної Могили, щоб влаштувати засідку.',
      'AttackChambulNo':
          'Ви з недовірою віднеслися до слів розвідника, що начебто там лише десять татар охороняє табун коней. Це може бути пасткою. Ви вирішили не нападати на татар.',
      'AttackChambul':
          'Розвідники побачили чамбул татар в степу біля Чорної Могили',
      'AttackChambulQuestion':
          'Зі сходом сонця до вас прискакав розвідник. Він побачили чамбул татар кількістю десять воїнів. Вони ведуть коней на пасовища. У вас є щанс пошарпать їх та забрати коней собі. Чи хочете ви вислати загін для відбиття коней?',
      'successTrapChambulOnWayBack':
          'Запорожці застали татар ще до того, як вони всі з\'єдналися в одне військо. З першим боєм козаки розсипали перший великий чамбул татар, а на наступний день прямо на переправі вирізали до ноги другу частину. Велика кількість бранців відмовилась повертатится назад до панів та розійшлася по хуторам і зимовниках. Частина подолян попросилась до вас в Слободу. Казки і оповіді про вашу слободу знають навіть на Поділлі.',
      'failureTrapChambulOnWayBack':
          'Не всі загони встигли приєднатися до запорожців. Прийнявши не рівний бій з татарами на переправі, козаки майже скинули татарське військо, але в останній момент до татар прийшов ще один чамбул та розбив наш кіш. Втрати дуже великі. Слобода втратила багато героїв...',
      'TrapChambulOnWayBackYes':
          'Порадившись зі своєю старшиною, ви вирішили виставити в загін всіх козаків, які можуть тримати зброю. Захист українських земель перед усім! Видавши запаси їжі і зброї, ви попрощались з сотнями, які рано вранці вирушили на з\'єднання з запорожцями.',
      'TrapChambulOnWayBackNo':
          'Ви і старшина дійшло згоди, що не можна залишати без оборони величезний шмат кордону з татарами і відмовили посланцям. Вони вас зрозуміли і поскакали до основних сил.',
      'TrapChambulOnWayBack': 'Грандіозна навала татар на Поділля.',
      'TrapChambulOnWayBackQuestion':
          'З Січі примчали два козаки. Війську Запорозькому стало відомо про величезний набіг татар на Поділля. Вони зараз повертаються назад в Крим з тисячею ясиру і величезним обозом награбованого. Кошовий просить всіх хто може приєднатися до православного війська і на Чорному Шляху розбити військо обрізаних. Знаючи, що ваша Слобода доволі велика, він розраховує на вашу допомогу.',
      'successHelpDefendSich':
          'Ваша залога на Січі повернулась назад без всяких пригод.',
      'failureHelpDefendSich':
          'Ваша залога, разом з іншими козаками, відігнали розбишак, які хотіли пошарпати Січ, поки основні сили були на морі. Злякавшись, що Січ не порожня, розбишаки утікли світ за очі.',
      'HelpDefendSichYes': 'Загін козаків вирушів разом з січовиками на Січ.',
      'HelpDefendSichNo':
          'Ви відмовили січовикам. Необхідно мати козаків для оборони слободи.',
      'HelpDefendSich': 'Дати козаків для залоги на Січі.',
      'HelpDefendSichQuestion':
          'Січовики попросили видати вам трохи козаків, які б могли обороняти Січ під час їх морського походу на турків. Так, як ваша Слобода ще не велика, то вас не беруть з собою в похід.',
      'successAttackPolishLands':
          'Ляхи вирішили атакувати козаків з наскоку, але їх кавалерія була розбита рушничним вогнем з-за возів. Швидко зробивши флангову атаку кіннотою, козаки завершили погром польських карателів. Здобули їх табір і відійшли назад, в Україну.',
      'failureAttackPolishLands':
          'Взяти ляхів з наскоку не вийшло. Обидві армії стали таборами і почали вести окопну війну. Ресурси у козаків закінчилися швидше і після перемовин з поляками козаки видали старшину і склали зброю. Ляхи не дотримали умов договору і жорстко покарали козаків. Запорозьке військо не скоро набере сил на ще одну таку оказію...',
      'AttackPolishLandsYes':
          'Вислати загін кінних козаків на допомогу січовикам.',
      'AttackPolishLandsNo': 'Залишитись на сторожі кордону з татарами.',
      'AttackPolishLands': 'Похід на Польшу.',
      'AttackPolishLandsQuestion':
          'Запорозьке товариство вирішило напасти на короні землі. Магнати накопчили багато солдат, щоб зробити упереджувальний удар по українцях. Тому кошовий скликає всіх козаків до походу на Польшу. Так як ваше село має досталь ресурсів людей і коней, то воно може приєднатися до походу.',
      'successSendMoneyToSchoolInKaniv':
          'Ви пожертвували гроші для розширення школи у Каневі. Тепер ще більше козацьких дітей зможуть отримати освіту. Світлий розум у дітей - це майбутнє України.',
      'SendMoneyToSchoolInKanivYes':
          'Ви виділили кошти на школу в Каневі. Посланці поїхали до Канева з зібраними коштами.',
      'SendMoneyToSchoolInKanivNo':
          'Ви відмовили у пожертві грошей на школу. Посланці поїхали далі по інших слободах збирати кошти.',
      'SendMoneyToSchoolInKaniv': 'Пожертва грошей на школу в Каневі.',
      'SendMoneyToSchoolInKanivQuestion':
          'До вас прибули козаки, які збирають на розбудову школи у Каневі. Просять допомогти по можливості. Навчені діти зможуть краще протистояти ієзуїтській чумі на наших землях.',
      'successSendMerchantToKanev':
          'Валка з товаром з успіхом дійшла до Канева. Продавши всю рибу і хутра, вона вирушили назад.',
      'failureSendMerchantToKanev':
          'Валка з товаром була атакована розбійниками. Весь товар був пограбований, але, на щастя, ніхто не постраждав.',
      'SendMerchantToKanevYes':
          'Козаки повантажили всю рибу і хутра на вози і невеликою валкою пішли зі сходом сонця на Канів.',
      'SendMerchantToKanevNo':
          'Зараз неспокійно в степу. Дуже багато розбишак і татар вештається то тут то там. Ви вирішили перечекати кращого сезону.',
      'SendMerchantToKanev': 'Відіслати валку з товаром до Канева.',
      'SendMerchantToKanevQuestion':
          'У вас накопичилось багато риби і хутра. Можна відіслати валку до Канева, щоб продати весь товар і отримати гроші. В степу зараз не спокійно, то ж вибір за вами.',
      'successAttackCatholicChurches':
          'Вночі сотня козаків разом з православними священиками увійшла до церкви. Католики вирядили загін жовнірів, але після короткої сутички вони всі розбіглися. Вам дістався їх невеличкий обоз і багаті дари від митрополита. Священа справа по поверненню українських земель і церков іде повним ходом.',
      'failureAttackCatholicChurches':
          'Хтось попередив ляхів про замисел митрополита. Вас зустріла озброєна чота ієзуїтів. Стався короткий рукопашний бій. Сили митрополита були відкинуті. Ви втратили декілька козаків забитими.',
      'AttackCatholicChurchesYes':
          'Ви з радістю вирішили допомогти митрополиту у цій святій справі. На допомогу йому ви вислали 20 козаків.',
      'AttackCatholicChurchesNo':
          'Ваша головна мета - оборона від татар. Свої церковні справи нехай попи вирішують самі.',
      'AttackCatholicChurches': 'Відбити православну парафію у католиків.',
      'AttackCatholicChurchesQuestion':
          'Благословеніший митрополит Києва Сильвестр Белькевич просить козацьке товариство відбити окуповану католиками парафію біля Білої Церкви. Він просить за допомогою вашої збройної присутністю переконати ляхів повернути церкву назад у володіння Православної метрополії.',
      'successHelpDefendAgainstCatholicRaiders':
          'Рано вранці польські найманці зробили спробу підбурити юрбу до штурму Лаври. Але козаци невеликими мобільнами групами відловлювали наймане бидло та польських перевдягнених в козацьке жовнірів й нещадно різали. Зачинщик штурму сховався в Андріївській церкві, але його звідти витягли та повісили на спуску до Подола. Андріївську церкву тут же захопили озброєні козаки і ввели туди правосланих священників. Контр операція була настільки вдалою, що митрополит вам жалував цілий скарб грошей і речей в знак подяки за охорону православної віри.',
      'failureHelpDefendAgainstCatholicRaiders':
          'Ляхи злякалися такої сили, яка прийшла на підтримку Лаври. Наймане бидло серед місцевих само розбіглося, а озброєні жовніри побоялися вступати з вами в бій. Митрополит в знак подяки дарував вам багаті подарунки.',
      'HelpDefendAgainstCatholicRaidersYes':
          'Ієзуїтська чума має бути зупинена. Ви з радістю вирішили допомогти митрополиту у цій святій справі. На допомогу йому ви вислали 30 озброєних козаків.',
      'HelpDefendAgainstCatholicRaidersNo':
          'Ваша головна мета - оборона від татар. Свої церковні справи нехай попи вирішують самі.',
      'HelpDefendAgainstCatholicRaiders': 'Захистити Києво-Печерську Лавру.',
      'HelpDefendAgainstCatholicRaidersQuestion':
          'Благословеніший митрополит Києва Сильвестр Белькевич прислав гінців до вільних земель. Йому стало відомо, що ляхи разом з ієзуїтами готують збройний напад з метою захоплення Києво-Печерської Лаври. Він просить вислать збройних козаків під Київ, щоб допомогти відбити атаку.',
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

  static CityPropsLocalizations cityPropsLocalizations =
      CityPropsLocalizations();

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
        case 'cityProps':
          return cityPropsLocalizations[split[1]];
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
      'resources': 'Resources',
      'cityBuildings': 'Town',
      'stock': 'Stock',
      'requiredForProductionBy': 'Required for production by',
      'requiredToBuildBy': 'Required for building',
      'output': 'Output',
      'input': 'Input',
      'build': 'Build',
      'makeTurn': 'Make Turn',
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
      'trainCossacks': 'Train cossacks',
      'cossacks': 'Cossacks',
      'bigSloboda': 'Big Sloboda',
      'normalSloboda': 'Small Sloboda',
      'notEnoughResources': 'has not enough',
      'sendCossacksToSich': 'Send cossacks to Sich',
      'sichHas': 'Sich has',
      'reset': 'Reset',
      'sichName': 'Sich',
    },
    'uk': {
      'overview': 'Головна',
      'events': 'Події',
      'resources': 'Ресурси',
      'cityBuildings': 'Будівлі',
      'stock': 'Склад',
      'requiredForProductionBy': 'Потребується у виробництві',
      'requiredToBuildBy': 'Потребується для будування',
      'output': 'Виробляє',
      'input': 'Потребує',
      'build': 'Побудувати',
      'makeTurn': 'Зробити хід',
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
      'citizens': 'Люди',
      'defense': 'Рівень захисту',
      'trainCossacks': 'Спорядити козаків',
      'cossacks': 'Козаки',
      'bigSloboda': 'Велика Слобода',
      'normalSloboda': 'Маленька Слобода',
      'notEnoughResources': 'недостає',
      'sendCossacksToSich': 'Відіслати козаків на Січ',
      'sichHas': 'На Січі є',
      'reset': 'Заново',
      'sichName': 'Запорізька Січ',
    }
  };

  static String get overview {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['overview'];
  }

  static String get resources {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['resources'];
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

  static String get trainCossacks {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['trainCossacks'];
  }

  static String get sendCossacksToSich {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['sendCossacksToSich'];
  }

  static String get cossacks {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['cossacks'];
  }

  static String get bigSloboda {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['bigSloboda'];
  }

  static String get normalSloboda {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['normalSloboda'];
  }

  static String get sichHas {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['sichHas'];
  }

  static String get reset {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]['reset'];
  }

  static String get sichName {
    return _localizedValues[SlobodaLocalizations.locale.languageCode]
        ['sichName'];
  }
}
