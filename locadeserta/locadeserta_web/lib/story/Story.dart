import 'dart:math';
import 'package:tuple/tuple.dart';
import 'package:flutter_web/foundation.dart';

class Story {
  final String title;
  final String description;
  final List<String> authors;
  final List<PassageBase> passages;
  PassageBase currentPassage;

  Story({
    @required this.title,
    @required this.description,
    @required this.authors,
    @required this.passages,
  }) {
    currentPassage = passages[0];
  }

  next(int option) {
    var next;
    if (option == null) {
      next = currentPassage.getNext(-1);
    } else {
      next = currentPassage.getNext(option);
    }

    currentPassage = passages.firstWhere((p) => p.id == next);
  }

  static generate() {
    var p1 = PassageContinue(
      id: 0,
      text:
          "Сонце сідало за рікою, заливаючи все навколо багряним сяйвом. Стрімка течія несла темну воду на південь, до моря. Вітерець стиха колихав очерет, розносячи запах ранньої осені та дим від вогнища. Поступово сутеніло",
      next: 1,
    );
    var p2 = PassageContinue(
      id: 1,
      text:
          "Дмитро нерухомо лежав у прибережних заростях далеко від води, прислухаючись до навколишніх звуків. Надокучлива комашня гризла обличчя та шию. Десь там, трохи далі на березі, де очерет поступається степовій траві та поодиноким деревцям, розташувалися навколо вогню троє чоловіків. Утікачу їх не було видно, однак інколи вітер приносив уривки розмови та брязкіт реманенту. Це були татари. Дмитро прислухався, намагаючись зрозуміти, чи вони тут по його душу.",
      next: 2,
    );

    var p3 = PassageContinue(
      id: 2,
      text:
          "Втікачу знову довелося повзти, бо берег піднімався все вище, аж ось незабаром з’явилося вогнище, яке ще жевріло самотньо у степу.",
      next: 3,
    );

    var p4 = PassageOption(
      id: 3,
      text: "У нечастих спалахах місячного сяйва можна було розгледіти силуети людей та коней. Двоє, схоже, спали на землі, один навпроти одного. Третій сидів ближче до вогню, спираючись на короткого списа, і, здавалося, теж заснув. Коней було видно гірше, вони дрімали десь з іншого боку багаття і їх, на перший погляд, було не менше п’яти.",
      options: [Tuple2(0, "Забрати торбинку та лук з сагайдаком"), Tuple2(1, "Пошукати татарську шаблю")]
    );

    return Story(
      title: "Після битви",
      description: "Тест",
      authors: ["Костя"],
      passages: [p1, p2, p3, p4],
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
        return PassageRandom(id: id, text: text, options: options);
    }
  }
}

class PassageContinue extends PassageBase {
  final ContinueTypes type = ContinueTypes.Continue;
  final int id;
  final String text;
  final String imagePath;
  final int next;

  PassageContinue(
      {@required this.id,
      @required this.text,
      this.imagePath,
      @required this.next})
      : super(id: id, text: text, type: ContinueTypes.Continue);

  int getNext(int option) {
    return next;
  }
}

class PassageRandom extends PassageBase {
  final ContinueTypes type = ContinueTypes.Random;
  final int id;
  final String text;
  final List<int> options;

  PassageRandom({this.id, this.text, this.options})
      : super(id: id, text: text, type: ContinueTypes.Random);

  int getNext(int option) {
    var random = Random();
    return random.nextInt(options.length);
  }
}

class PassageOption extends PassageBase {
  final ContinueTypes type = ContinueTypes.Option;
  final int id;
  final String text;
  final List<Tuple2<int, String>> options;

  PassageOption(
      {@required this.id, @required this.text, @required this.options})
      : super(id: id, text: text, type: ContinueTypes.Option);

  int getNext(int option) {
    if (option >= options.length) {
      throw "Option number $option is bigger than maxium amouint of options: ${options.length}";
    }
    return options[option].item1;
  }
}

abstract class PassageBase {
  final ContinueTypes type;
  final int id;
  final String text;
  final bool canContinue = true;

  PassageBase({@required this.type, @required this.id, @required this.text});

  int getNext(int option);
}

enum ContinueTypes { Continue, Random, Option }
