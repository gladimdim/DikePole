import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:locadeserta/models/background_image.dart';

class Story {
  String title;
  String description;
  List<String> authors;
  Page root;
  final List<HistoryItem> history = [];
  int currentPageIndex;
  Page _currentPage;

  Story({
    @required this.title,
    @required this.description,
    @required this.authors,
    @required this.root
  }) {
    _currentPage = root;
  }


  _addCurrentPassage() {
    history.add(
      HistoryItem(
        text: _currentPage.getCurrentText(),
        imageType: _currentPage.getCurrentNode().imageType,
      ),
    );
  }

  toJson() {
    return jsonEncode({
      "title": title,
      "description": description,
      "": passages,
      "authors": authors,
    });
  }

  static Story fromJson(String input) {
    Map map = jsonDecode(input);
    List passages = map["passages"];
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

    List authors = map["authors"];
    List<String> parsedAuthors = authors.map((a) => a.toString()).toList();

    return Story(
      title: map["title"],
      description: map["description"],
      passages: parsedPassages,
      authors: parsedAuthors,
    );
  }

  static generate() {
    var p1 = PageNode(
        text:
            "The sun was setting over the river, casting a crimson glow over everything. A swift current swept the dark water south to the sea while the wind quietly rustled the reeds, carrying the scent of autumn and smoke from the fire. Twilight was settling in.",
        imageType: ImageType.RIVER);
    var p2 = PageNode(
        text:
            "Dmytro lay hidden in the thicket far from the water, listening carefully to the nearby sounds. Pesky gnats needled his face and neck. A little further off on the shore, where the reeds gave place to steppe grass and sparsely growing trees, three men had settled near a fire. The runaway couldn’t see them, but he could sometimes hear fragments of their conversation and the clatter of provisions passed on by the wind. They were Tatars. Dmytro was trying to hear whether they were there for him.",
        imageType: ImageType.BULRUSH);

    var p3 = PageNode(
        text:
            "The Cossack lay like this for a long time, covering his head with his hands until it was completely dark. The wind increased, blocking out all other sounds except for the haunting song of the rustling reeds. The wispy clouds were driven westward, creating a covering for the weak light of the crescent moon. Dmytro couldn’t wait any longer. He had to do something. Gripping tightly a good combat knife, the only thing he managed to take from the boat when running away, he slowly crawled to the path that led to the river. He waited a while before getting up and, trying to step as lightly as possible, made his way to the river. There was no one on the dark path. He squatted and started to drink the cold river water, cupping it in his hand. From time to time, the moon and the thick clouds reflected on the river’s service. Suddenly, a girl’s face was seen. The man sprang back and stared at the spot where he had seen the bright eyes of a young girl. But there was nothing there – only the moonlight that sometimes shone through the clouds. He crossed himself and went back, whispering a prayer. Then he turned and made his way to where the wall of reeds ended.",
        imageType: ImageType.BULRUSH);

    var p4 = PageNode(
        text:
            "The runaway had to crawl once again since the river bank had risen. Suddenly, he spotted a solitary fire glowing in the dark sea of the steppe.",
        imageType: ImageType.RIVER);

    var p5 = PageNode(
        text:
            "In the rare times the moonlight was visible, it was possible to glimpse the silhouettes of people and horses. Two were sleeping on the ground facing each other. A third was sitting closer to the fire, leaning against a short spear and, seemingly, also sleeping. It was harder to make out the horses as they slept on the other side of the fire, but there appeared to be at least five of them.",
        imageType: ImageType.CAMP);

    var p6 = PageNode(
        text:
            "In the rare times the moonlight was visible, it was possible to glimpse the silhouettes of people and horses. Two were sleeping on the ground facing each other. A third was sitting closer to the fire, leaning against a short spear and, seemingly, also sleeping. It was harder to make out the horses as they slept on the other side of the fire, but there appeared to be at least five of them.",
        imageType: ImageType.CAMP);
    var page = Page(

    );
    var p7 = PassageOption(
        id: 6,
        text:
            "Dmytro crawled to the nearest Tatar and quietly rose to his knees, ready to stick the knife in the Tatar’s eye if he moved. Nearby was a bow, a quiver with arrows, and a knapsack.",
        options: [
          NextOption(target: 0, text: "Take the bow, quiver and knapsack"),
          NextOption(target: 1, text: "Look for a Tatar saber")
        ],
        imageType: ImageType.CAMP);

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

class HistoryItem {
  final String text;
  final ImageType imageType;

  HistoryItem({@required this.text, this.imageType});
}

class NextOption {
  final int target;
  final String text;

  NextOption({this.target, this.text});
}

class Page {
  List<PageNode> nodes;
  int currentIndex;
  int id;

  Page parent;

  List<Page> next;

  EndType endType;

  Page(
      {this.nodes = const [],
      this.currentIndex = 0,
      @required this.id,
      this.parent,
      this.next = const [],
      this.endType});

  PageNode getCurrentNode() {
    return nodes.elementAt(currentIndex);
  }

  String getCurrentText() {
    return getCurrentNode().text;
  }

  void addNodeWithText(String text) {
    var node = PageNode(text: text);
    nodes.add(node);
  }

  void removeNodeAtIndex(int i) {
    nodes.removeAt(i);
  }

  void addNodeWithTextAtIndex(String text, int index) {
    var node = PageNode(text: text);
    nodes.insert(index, node);
  }

  changeParent(Page page) {
    parent = page;
  }

  isRoot() {
    return parent == null;
  }

  isTheEnd() {
    return endType == null;
  }

  static Page fromJSON(String input) {
    var map = jsonDecode(input);
    List next = map["next"];
    List nodes = map["nodes"];

    return Page(
      id: map["id"],
      next: next.map((n) => Page.fromJSON(n)),
      endType: endTypeFromString(map["endType"]),
      nodes: nodes.map((n) => PageNode.fromJSON(n))
    );
  }
}

enum EndType { DEAD, ALIVE }

String endTypeToString(EndType endType) {
  switch (endType) {
    case EndType.ALIVE: return "ALIVE";
    case EndType.DEAD: return "DEAD";
    default: return "";
  }
}

EndType endTypeFromString(String input) {
  switch (input) {
    case "ALIVE": return EndType.ALIVE;
    case "DEAD": return EndType.DEAD;
    default: return null;
  }
}


class PageNode {
  ImageType imageType;
  String text;

  PageNode({this.imageType, @required this.text});

  static fromJSON(String input) {
    var map = jsonDecode(input);
    return PageNode(
      imageType: imageTypeFromString(map["imageType"]),
      text: map["text"],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "text": text,
      "imageType": imageTypeToString(imageType),
    };
  }
}
