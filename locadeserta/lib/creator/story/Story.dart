import 'package:tuple/tuple.dart';
import 'package:flutter/foundation.dart';
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
    var p1 = PassageContinue(
        id: 0,
        text:
            "The sun was setting over the river, casting a crimson glow over everything. A swift current swept the dark water south to the sea while the wind quietly rustled the reeds, carrying the scent of autumn and smoke from the fire. Twilight was settling in.",
        next: 1,
        imagePath: "images/background/river/10.jpg");
    var p2 = PassageContinue(
        id: 1,
        text:
            "Dmytro lay hidden in the thicket far from the water, listening carefully to the nearby sounds. Pesky gnats needled his face and neck. A little further off on the shore, where the reeds gave place to steppe grass and sparsely growing trees, three men had settled near a fire. The runaway couldn’t see them, but he could sometimes hear fragments of their conversation and the clatter of provisions passed on by the wind. They were Tatars. Dmytro was trying to hear whether they were there for him.",
        next: 2,
        imagePath: "images/background/bulrush/5.jpg");

    var p3 = PassageContinue(
        id: 2,
        text:
            "The Cossack lay like this for a long time, covering his head with his hands until it was completely dark. The wind increased, blocking out all other sounds except for the haunting song of the rustling reeds. The wispy clouds were driven westward, creating a covering for the weak light of the crescent moon. Dmytro couldn’t wait any longer. He had to do something. Gripping tightly a good combat knife, the only thing he managed to take from the boat when running away, he slowly crawled to the path that led to the river. He waited a while before getting up and, trying to step as lightly as possible, made his way to the river. There was no one on the dark path. He squatted and started to drink the cold river water, cupping it in his hand. From time to time, the moon and the thick clouds reflected on the river’s service. Suddenly, a girl’s face was seen. The man sprang back and stared at the spot where he had seen the bright eyes of a young girl. But there was nothing there – only the moonlight that sometimes shone through the clouds. He crossed himself and went back, whispering a prayer. Then he turned and made his way to where the wall of reeds ended.",
        next: 3,
        imagePath: "images/background/river/0.jpg");

    var p4 = PassageContinue(
        id: 3,
        text:
            "The runaway had to crawl once again since the river bank had risen. Suddenly, he spotted a solitary fire glowing in the dark sea of the steppe.",
        next: 4,
        imagePath: "images/background/forest/3.jpg");

    var p5 = PassageContinue(
        id: 4,
        text:
            "In the rare times the moonlight was visible, it was possible to glimpse the silhouettes of people and horses. Two were sleeping on the ground facing each other. A third was sitting closer to the fire, leaning against a short spear and, seemingly, also sleeping. It was harder to make out the horses as they slept on the other side of the fire, but there appeared to be at least five of them.",
        next: 5,
        imagePath: "images/background/forest/3.jpg");

    var p6 = PassageContinue(
        id: 5,
        text:
            "In the rare times the moonlight was visible, it was possible to glimpse the silhouettes of people and horses. Two were sleeping on the ground facing each other. A third was sitting closer to the fire, leaning against a short spear and, seemingly, also sleeping. It was harder to make out the horses as they slept on the other side of the fire, but there appeared to be at least five of them.",
        next: 6,
        imagePath: "images/background/forest/3.jpg");

    var p7 = PassageOption(
      id: 6,
      text:
          "Dmytro crawled to the nearest Tatar and quietly rose to his knees, ready to stick the knife in the Tatar’s eye if he moved. Nearby was a bow, a quiver with arrows, and a knapsack.",
      options: [
        Tuple2(0, "Take the bow, quiver and knapsack"),
        Tuple2(1, "Look for a Tatar saber")
      ],
      imagePath: "images/background/camp/2.jpg",
    );

    var story = Story(
      title: "After the battle",
      description:
          "At the beginning of XVII century a confrontation flares up between Polish-Lithuanian Commonwealth and Ottoman Empire. As a result of a devastating defeat in the Battle of Cecora, a lot of noblemen, cossacks and soldiers perished or were captured by Turks and Tatars. A fate of a young cossack, wayfaring through the Wild FIelds in a desperate attempt to escape from captivity, depends on a reader of this interactive fiction. All challenges are equally hard: survive in a steppe, avoid the revenge of Tatars, win the trust of cossack fishermen and return home. But the time of the final battle that will change history is coming. Will the main character be able to participate in it and stay alive and where his life will go from there - only You know the answer.",
      authors: ["Konstantin Boytsov", "Anastasiia Tsapenko"],
      passages: [p1, p2, p3, p4, p5, p6, p7],
    );
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

enum PassageTypes { Continue, Option }

PassageTypes stringToPassageType(String input) {
  switch (input) {
    case "Option":
      return PassageTypes.Option;
    case "Continue":
      return PassageTypes.Continue;
    default:
      throw "Passage type string not recognized: $input";
  }
}

String passageTypeToString(PassageTypes type) {
  switch (type) {
    case PassageTypes.Option:
      return "Option";
    case PassageTypes.Continue:
      return "Continue";
    default:
      throw "PassageType $type was not recognized";
  }
}
