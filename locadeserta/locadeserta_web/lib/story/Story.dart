import 'dart:math';
import 'package:tuple/tuple.dart';
import 'package:flutter_web/foundation.dart';
import 'dart:convert';

class Story {
  String title;
  String description;
  List<String> authors;
  final List<PassageBase> passages;
  final List<HistoryItem> history = [];
  final List<String> variables = [];

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

  toJson() {
    return jsonEncode({
      "title": title,
      "description": description,
      "passages": passages,
      "authors": authors,
    });
  }

  static Story fromJson(String input) {
    Map map = jsonDecode(input);
    List passages = jsonDecode(map["passages"]);
    List<PassageBase> parsedPassages = passages.map((p) {
      switch (p["type"]) {
        case "Random":
          return PassageRandom.fromJson(jsonEncode(p));
        case "Continue":
          return PassageContinue.fromJson(jsonEncode(p));
        case "Option":
          return PassageOption.fromJson(jsonEncode(p));
        default:
          throw "Type is not recognized for passage: $p";
      }
    }).toList();

    List authors = jsonDecode(map["authors"]);
    List<String> parsedAuthors = authors.map((a) => a.toString()).toList();

    return Story(
      title: map["title"],
      description: map["description"],
      passages: parsedPassages,
      authors: parsedAuthors,
    );
  }

  static generate() {
    var p1 = PassageRandom(
        id: 0,
        text:
            "Сонце сідало за рікою, заливаючи все навколо багряним сяйвом. Стрімка течія несла темну воду на південь, до моря. Вітерець стиха колихав очерет, розносячи запах ранньої осені та дим від вогнища. Поступово сутеніло",
        next: [1, 2, 3],
        imagePath: "images/background/river/10.jpg");
    var p2 = PassageContinue(
        id: 1,
        text:
            "Дмитро нерухомо лежав у прибережних заростях далеко від води, прислухаючись до навколишніх звуків. Надокучлива комашня гризла обличчя та шию. Десь там, трохи далі на березі, де очерет поступається степовій траві та поодиноким деревцям, розташувалися навколо вогню троє чоловіків. Утікачу їх не було видно, однак інколи вітер приносив уривки розмови та брязкіт реманенту. Це були татари. Дмитро прислухався, намагаючись зрозуміти, чи вони тут по його душу.",
        next: 2,
        imagePath: "images/background/bulrush/5.jpg");

    var p3 = PassageContinue(
        id: 2,
        text:
            "Втікачу знову довелося повзти, бо берег піднімався все вище, аж ось незабаром з’явилося вогнище, яке ще жевріло самотньо у степу.",
        next: 3,
        imagePath: "images/background/river/0.jpg");

    var p4 = PassageContinue(
        id: 3,
        text:
            "У нечастих спалахах місячного сяйва можна було розгледіти силуети людей та коней. Двоє, схоже, спали на землі, один навпроти одного. Третій сидів ближче до вогню, спираючись на короткого списа, і, здавалося, теж заснув. Коней було видно гірше, вони дрімали десь з іншого боку багаття і їх, на перший погляд, було не менше п’яти.",
        next: 4,
        imagePath: "images/background/camp/3.jpg");

    var p5 = PassageOption(
      id: 4,
      text:
          "Дмитро підповз до найближчого сплячого татарина та тихо підвівся на коліна, підготувавшись встромити ножа йому в око, якщо той ворухнеться. Поруч лежав лук з сагайдаком та якась торбинка.",
      options: [
        Tuple2(5, "Забрати торбинку та лук з сагайдаком"),
        Tuple2(6, "Пошукати татарську шаблю")
      ],
      imagePath: "images/background/camp/2.jpg",
    );

    var p6 = PassageRandom(
      id: 5,
      text:
          "Козак більше нічого не ризикнув чіпати і зі своєю здобиччю обережно повернувся до очерету та почав поступово віддалятися від вершників, прямуючи вздовж річки вверх за течією.",
      next: [0, 1, 2],
      imagePath: "images/background/river/2.jpg",
    );

    var p7 = PassageContinue(
      id: 6,
      text:
          "Обережно відклавши ці речі ближче до себе, Дмитро нишпорив оком у пошуках шаблі. Вона теж лежала поруч, відчеплена з гаку, але сплячий обіймав її, як дитина - улюблену ляльку.",
      next: 2,
      imagePath: "images/background/camp/3.jpg",
    );

    var story = Story(
      title: "Після битви",
      description: "Тест",
      authors: ["Костя"],
      passages: [p1, p2, p3, p4, p5, p6, p7],
    );

    print(story.toJson());
    return story;
  }
}

class Passage {
  final String text;
  final PassageTypes continueType;

  Passage({this.text, this.continueType});

  static createWithType(PassageTypes continueType, {text, id, options, next}) {
    switch (continueType) {
      case PassageTypes.Continue:
        return PassageContinue(text: text, id: id, next: next);
      case PassageTypes.Option:
        return PassageOption(id: id, text: text, options: options);
      case PassageTypes.Random:
        return PassageRandom(id: id, text: text, next: options);
    }
  }
}

class PassageContinue extends PassageBase {
  final PassageTypes type = PassageTypes.Continue;
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
            type: PassageTypes.Continue,
            imagePath: imagePath);

  int getNext(int option) {
    return next;
  }

  Map<String, dynamic> toJson() {
    return {
      "type": "Continue",
      "id": id,
      "text": text,
      "imagePath": imagePath,
      "next": next,
    };
  }

  static PassageContinue fromJson(String input) {
    Map map = jsonDecode(input);

    return PassageContinue(
      id: map["id"],
      text: map["text"],
      imagePath: map["imagePath"],
      next: map["next"],
    );
  }

  int getNexts() {
    return next;
  }
}

class HistoryItem {
  final String text;
  final String imagePath;

  HistoryItem({@required this.text, this.imagePath});
}

class PassageRandom extends PassageBase {
  final PassageTypes type = PassageTypes.Random;
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
          type: PassageTypes.Random,
          imagePath: imagePath,
        );

  int getNext(int option) {
    var random = Random();
    var nextRandom = random.nextInt(next.length);
    print("Next random: $nextRandom");
    return next[nextRandom];
  }

  static PassageRandom fromJson(String input) {
    var map = jsonDecode(input);
    List nexts = jsonDecode(map["next"]);
    List<int> parsedNext = nexts.map((n) => n as int).toList();
    return PassageRandom(
      id: map["id"],
      text: map["text"],
      next: parsedNext,
      imagePath: map["imagePath"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": "Random",
      "id": id,
      "text": text,
      "imagePath": imagePath,
      "next": next,
    };
  }

  List<int> getNexts() {
    return next;
  }
}

class PassageOption extends PassageBase {
  final PassageTypes type = PassageTypes.Option;
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
          type: PassageTypes.Option,
          imagePath: imagePath,
        );

  int getNext(int option) {
    if (option >= options.length) {
      throw "Option number $option is bigger than maxium amount of options: ${options.length}";
    }
    return options[option].item1;
  }

  Map<String, dynamic> toJson() {
    return {
      "type": "Option",
      "id": id,
      "text": text,
      "options": options
          .map((option) => {
                "id": option.item1,
                "text": option.item2,
              })
          .toList(),
      "imagePath": imagePath,
    };
  }

  List<Tuple2<int, String>> getNexts() {
    return options;
  }

  static PassageOption fromJson(String input) {
    var map = jsonDecode(input);
    List options = map["options"];
    List<Tuple2<int, String>> parsedOptions = options
        .map(
          (mapOption) => Tuple2(
            mapOption["id"] as int,
            mapOption["text"] as String,
          ),
        )
        .toList();
    return PassageOption(
      id: map["id"],
      text: map["text"],
      imagePath: map["imagePath"],
      options: parsedOptions,
    );
  }
}

abstract class PassageBase {
  final PassageTypes type;
  final int id;
  final String text;
  final bool canContinue = true;
  final String imagePath;

  Map<String, dynamic> toJson();

  PassageBase({
    @required this.type,
    @required this.id,
    @required this.text,
    this.imagePath,
  });

  int getNext(int option);

  getNexts();
}

enum PassageTypes { Continue, Random, Option }

PassageTypes stringToPassageType(String input) {
  switch (input) {
    case "Option": return PassageTypes.Option;
    case "Continue": return PassageTypes.Continue;
    case "Random": return PassageTypes.Random;
    default: throw "Passage type string not recognized: $input";
  }
}

String passageTypeToString(PassageTypes type) {
  switch (type) {
    case PassageTypes.Option: return "Option";
    case PassageTypes.Continue: return "Continue";
    case PassageTypes.Random: return "Random";
    default: throw "PassageType $type was not recognized";
  }
}
