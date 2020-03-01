import 'package:sloboda/extensions/list.dart';

class Citizen {
  var assignedTo;
  String name;

  void free() {
    assignedTo = null;
  }

  Citizen() {
    _generateName();
  }

  get occupied {
    return assignedTo != null;
  }

  _generateName() {
    name = '${firstNames.takeRandom()} ${lastName.takeRandom()}';
  }

  static getIconPath() {
    return 'images/city_buildings/citizen_64.png';
  }
}

List firstNames = [
  'Тишко',
  'Федір',
  'Кіндрат',
  'Семен',
  'Гринько',
  'Луцик',
  'Андрій',
  'Дмитро',
  'Іван',
  'Клим',
  'Павло',
  'Яцько',
  'Мишко',
  'Тарас',
  'Іван',
  'Кіндрат',
  'Ігнат',
  'Ничіпор',
];
List lastName = [
  'Смілий',
  'Бублик',
  'Косиць',
  'Дорош',
  'Безпояско',
  'Ященко',
  'Ревко',
  'Карп',
  'Клименко',
  'Сметрик',
  'Скорик',
  'Адаменко',
  'Павленко',
  'Скоробагаченко',
  'Красненко',
  'Пилипенко',
  'Царенко',
  'Голоденко',
  'Задорожний'
];
