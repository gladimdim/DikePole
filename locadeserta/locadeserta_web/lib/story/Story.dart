import 'dart:math';
import 'package:tuple/tuple.dart';
import 'package:flutter_web/foundation.dart';

class Story {
  final String title;
  final String description;
  final List<String> authors;
  final List<PassageBase> passages;
  final List<HistoryItem> history = [];

  PassageBase currentPassage;

  Story({
    @required this.title,
    @required this.description,
    @required this.authors,
    @required this.passages,
  }) {
    currentPassage = passages[0];
    _addCurrentPassage();
  }

  next(int option) {
    var next;
    if (option == null) {
      next = currentPassage.getNext(-1);
    } else {
      next = currentPassage.getNext(option);
    }

    try {
      currentPassage = passages.firstWhere((p) => p.id == next);
    } catch (e) {
      currentPassage = passages[0];
    }

    _addCurrentPassage();
  }

  _addCurrentPassage() {
    history.add(
      HistoryItem(
        text: currentPassage.text,
        imagePath: currentPassage.imagePath,
      ),
    );
  }

  static generate() {
    var p1 = PassageRandom(
        id: 0,
        text:
            "Сонце сідало за рікою, заливаючи все навколо багряним сяйвом. Стрімка течія несла темну воду на південь, до моря. Вітерець стиха колихав очерет, розносячи запах ранньої осені та дим від вогнища. Поступово сутеніло",
        next: [1, 2, 3],
        imagePath: "images/background/river/");
    var p2 = PassageContinue(
        id: 1,
        text:
            "Дмитро нерухомо лежав у прибережних заростях далеко від води, прислухаючись до навколишніх звуків. Надокучлива комашня гризла обличчя та шию. Десь там, трохи далі на березі, де очерет поступається степовій траві та поодиноким деревцям, розташувалися навколо вогню троє чоловіків. Утікачу їх не було видно, однак інколи вітер приносив уривки розмови та брязкіт реманенту. Це були татари. Дмитро прислухався, намагаючись зрозуміти, чи вони тут по його душу.",
        next: 2,
        imagePath: "images/background/bulrush/");

    var p3 = PassageContinue(
        id: 2,
        text:
            "Втікачу знову довелося повзти, бо берег піднімався все вище, аж ось незабаром з’явилося вогнище, яке ще жевріло самотньо у степу.",
        next: 3,
        imagePath: "images/background/river/");

    var p4 = PassageContinue(
        id: 3,
        text:
            "У нечастих спалахах місячного сяйва можна було розгледіти силуети людей та коней. Двоє, схоже, спали на землі, один навпроти одного. Третій сидів ближче до вогню, спираючись на короткого списа, і, здавалося, теж заснув. Коней було видно гірше, вони дрімали десь з іншого боку багаття і їх, на перший погляд, було не менше п’яти.",
        next: 4,
        imagePath: "images/background/camp/");

    var p5 = PassageOption(
      id: 4,
      text:
          "Дмитро підповз до найближчого сплячого татарина та тихо підвівся на коліна, підготувавшись встромити ножа йому в око, якщо той ворухнеться. Поруч лежав лук з сагайдаком та якась торбинка.",
      options: [
        Tuple2(5, "Забрати торбинку та лук з сагайдаком"),
        Tuple2(6, "Пошукати татарську шаблю")
      ],
      imagePath: "images/background/camp/",
    );

    var p6 = PassageRandom(
      id: 5,
      text:
          "Козак більше нічого не ризикнув чіпати і зі своєю здобиччю обережно повернувся до очерету та почав поступово віддалятися від вершників, прямуючи вздовж річки вверх за течією.",
      next: [8, 9, 10],
      imagePath: "images/background/river/",
    );

    var p7 = PassageContinue(
      id: 6,
      text:
          "Обережно відклавши ці речі ближче до себе, Дмитро нишпорив оком у пошуках шаблі. Вона теж лежала поруч, відчеплена з гаку, але сплячий обіймав її, як дитина - улюблену ляльку.",
      next: 7,
      imagePath: "images/background/camp/",
    );

    return Story(
      title: "Після битви",
      description: "Тест",
      authors: ["Костя"],
      passages: [p1, p2, p3, p4, p5, p6, p7],
    );
  }
}

class Passage {
  final String text;
  final ContinueTypes continueType;

  Passage({this.text, this.continueType});

  static createWithType(ContinueTypes continueType, {text, id, options, next}) {
    switch (continueType) {
      case ContinueTypes.Continue:
        return PassageContinue(text: text, id: id, next: next);
      case ContinueTypes.Option:
        return PassageOption(id: id, text: text, options: options);
      case ContinueTypes.Random:
        return PassageRandom(id: id, text: text, next: options);
    }
  }
}

class PassageContinue extends PassageBase {
  final ContinueTypes type = ContinueTypes.Continue;
  final int id;
  final String text;
  final String imagePath;
  final int next;

  PassageContinue({
    @required this.id,
    @required this.text,
    this.imagePath,
    @required this.next,
  }) : super(
            id: id,
            text: text,
            type: ContinueTypes.Continue,
            imagePath: imagePath);

  int getNext(int option) {
    return next;
  }
}

class HistoryItem {
  final String text;
  final String imagePath;

  HistoryItem({@required this.text, this.imagePath});
}

class PassageRandom extends PassageBase {
  final ContinueTypes type = ContinueTypes.Random;
  final int id;
  final String text;
  final List<int> next;
  final String imagePath;

  PassageRandom({
    @required this.id,
    @required this.text,
    @required this.next,
    this.imagePath,
  }) : super(
          id: id,
          text: text,
          type: ContinueTypes.Random,
          imagePath: imagePath,
        );

  int getNext(int option) {
    var random = Random();
    var nextRandom = random.nextInt(next.length);
    print("Next random: $nextRandom");
    return next[nextRandom];
  }
}

class PassageOption extends PassageBase {
  final ContinueTypes type = ContinueTypes.Option;
  final int id;
  final String text;
  final List<Tuple2<int, String>> options;
  final String imagePath;

  PassageOption({
    @required this.id,
    @required this.text,
    @required this.options,
    this.imagePath,
  }) : super(
          id: id,
          text: text,
          type: ContinueTypes.Option,
          imagePath: imagePath,
        );

  int getNext(int option) {
    if (option >= options.length) {
      throw "Option number $option is bigger than maxium amount of options: ${options.length}";
    }
    return options[option].item1;
  }
}

abstract class PassageBase {
  final ContinueTypes type;
  final int id;
  final String text;
  final bool canContinue = true;
  final String imagePath;

  PassageBase({
    @required this.type,
    @required this.id,
    @required this.text,
    this.imagePath,
  });

  int getNext(int option);
}

enum ContinueTypes { Continue, Random, Option }
