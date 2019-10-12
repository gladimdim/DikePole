import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

import 'package:onlineeditor/models/background_image.dart';

class Story {
  String title;
  String description;
  String authors;
  Page root;
  List<HistoryItem> history = [];
  Page currentPage;

  BehaviorSubject _streamHistory = BehaviorSubject<List<HistoryItem>>();
  Stream historyChanges;
  Story(
      {@required this.title,
      @required this.description,
      @required this.authors,
      @required this.root}) {
    currentPage = root;
    historyChanges = _streamHistory.stream;
    _logCurrentPassageToHistory();
  }

  void reset() {
    history = [];
    currentPage = root;
    currentPage.currentIndex = 0;
    _logCurrentPassageToHistory();
  }

  _logCurrentPassageToHistory() {
    if (currentPage.getCurrentNode().imageType != null) {
      var backgroundImage = BackgroundImage.getRandomImageForType(
          currentPage.getCurrentNode().imageType);
      history.add(
        HistoryItem(
          text: currentPage.getCurrentText(),
          imagePath: [
            backgroundImage.getImagePath(),
            backgroundImage.getImagePathColored()
          ],
        ),
      );
    } else {
      history.add(
        HistoryItem(
          text: currentPage.getCurrentText(),
        ),
      );
    }

    _streamHistory.sink.add(history);
  }

  doContinue() {
    if (canContinue()) {
      currentPage.nextNode();
      _logCurrentPassageToHistory();
    } else {
      throw "End of next options";
    }
  }

  goToNextPage(PageNext next) {
    history.add(
      HistoryItem(text: next.text),
    );
    currentPage = next.nextPage;
    currentPage.currentIndex = 0;
  }

  bool canContinue() {
    return currentPage.hasNext();
  }

  toJson() {
    return jsonEncode({
      "title": title,
      "description": description,
      "authors": authors,
      "root": root.toMap(),
    });
  }

  toStateJson() {
    return jsonEncode({
      "title": title,
      "description": description,
      "authors": authors,
      "root": root.toMap(),
      "currentPage": currentPage.toMap(),
      "history": history.map((historyItem) => historyItem.toMap()).toList(),
    });
  }

  static Story fromJson(String input) {
    Map map = jsonDecode(input);
    var rootMap = map["root"];
    var rootPage = Page.fromMap(rootMap);
    String authors = map["authors"];
    return Story(
      title: map["title"],
      description: map["description"],
      root: rootPage,
      authors: authors,
    );
  }

  static generate() {
    var story = Story(
      title: "After the battle",
      description:
          "At the beginning of XVII century a confrontation flares up between Polish-Lithuanian Commonwealth and Ottoman Empire. As a result of a devastating defeat in the Battle of Cecora, a lot of noblemen, cossacks and soldiers perished or were captured by Turks and Tatars. A fate of a young cossack, wayfaring through the Wild FIelds in a desperate attempt to escape from captivity, depends on a reader of this interactive fiction. All challenges are equally hard: survive in a steppe, avoid the revenge of Tatars, win the trust of cossack fishermen and return home. But the time of the final battle that will change history is coming. Will the main character be able to participate in it and stay alive and where his life will go from there - only You know the answer.",
      authors: "Konstantin Boytsov, Anastasiia Tsapenko",
      root: Page.generate(),
    );
    return story;
  }

  Page findParentOfPage(Page page) {
    var queue = Queue<Page>();
    queue.add(root);
    while (queue.isNotEmpty) {
      var p = queue.removeFirst();
      if (p.next.where((pageNext) => pageNext.nextPage == page).length == 1) {
        return p;
      } else {
        queue.addAll(p.next.map((n) => n.nextPage));
      }
    }
    return null;
  }

  dispose() {
    _streamHistory.close();
  }
}

class HistoryItem {
  final String text;
  final List<String> imagePath;

  HistoryItem({@required this.text, this.imagePath});

  toMap() {
    return {
      "text": text,
      "imagePath": imagePath,
    };
  }
}

class Page {
  List<PageNode> nodes;
  int currentIndex;

  Page parent;

  List<PageNext> next;

  EndType endType;

  Page({this.nodes, this.currentIndex = 0, this.next, this.endType}) {
    if (next == null) {
      next = List();
    }
    if (nodes == null) {
      nodes = List();
    }
  }

  PageNode getCurrentNode() {
    return nodes.elementAt(currentIndex);
  }

  bool hasNext() {
    return currentIndex + 1 < nodes.length;
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

  void removeNode(PageNode node) {
    nodes.remove(node);
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
    return endType != null;
  }

  void nextNode() {
    currentIndex++;
    if (currentIndex >= nodes.length) {
      throw "End of nodes for current page";
    }
  }

  void addNextPageWithText(String text) {
    var page = Page();
    next.add(PageNext(text: text, nextPage: page));
  }

  void removeNextPage(PageNext page) {
    next.remove(page);
  }

  static Page fromJSON(String input) {
    var map = jsonDecode(input);
    List next = map["next"];
    List nodes = map["nodes"];

    return Page(
      next: next.map((n) => PageNext.fromMap(n)).toList(),
      endType: endTypeFromString(map["endType"]),
      nodes: nodes.map((n) => PageNode.fromJSON(n)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "endType": endTypeToString(endType),
      "next": next.map((n) => n.toMap()).toList(),
      "nodes": nodes.map((n) => n.toMap()).toList(),
    };
  }

  static Page fromMap(Map<String, dynamic> map) {
    List next = map["next"];
    List<PageNext> parsedNext = List.from(next.map((n) => PageNext.fromMap(n)));
    List nodes = map["nodes"];
    List<PageNode> parsedNodes =
        List.from(nodes.map((n) => PageNode.fromMap(n)));

    return Page(
      next: parsedNext,
      endType: endTypeFromString(map["endType"]),
      nodes: parsedNodes,
    );
  }

  static Page generate() {
    var p1 = PageNode(
      text:
          "The sun was setting over the river, casting a crimson glow over everything. A swift current swept the dark water south to the sea while the wind quietly rustled the reeds, carrying the scent of autumn and smoke from the fire. Twilight was settling in.",
    );
    var p2 = PageNode(
      text:
          "Dmytro lay hidden in the thicket far from the water, listening carefully to the nearby sounds. Pesky gnats needled his face and neck. A little further off on the shore, where the reeds gave place to steppe grass and sparsely growing trees, three men had settled near a fire. The runaway couldn’t see them, but he could sometimes hear fragments of their conversation and the clatter of provisions passed on by the wind. They were Tatars. Dmytro was trying to hear whether they were there for him.",
    );

    var p3 = PageNode(
      text:
          "The Cossack lay like this for a long time, covering his head with his hands until it was completely dark. The wind increased, blocking out all other sounds except for the haunting song of the rustling reeds. The wispy clouds were driven westward, creating a covering for the weak light of the crescent moon. Dmytro couldn’t wait any longer. He had to do something. Gripping tightly a good combat knife, the only thing he managed to take from the boat when running away, he slowly crawled to the path that led to the river. He waited a while before getting up and, trying to step as lightly as possible, made his way to the river. There was no one on the dark path. He squatted and started to drink the cold river water, cupping it in his hand. From time to time, the moon and the thick clouds reflected on the river’s service. Suddenly, a girl’s face was seen. The man sprang back and stared at the spot where he had seen the bright eyes of a young girl. But there was nothing there – only the moonlight that sometimes shone through the clouds. He crossed himself and went back, whispering a prayer. Then he turned and made his way to where the wall of reeds ended.",
    );

    var p4 = PageNode(
      text:
          "The runaway had to crawl once again since the river bank had risen. Suddenly, he spotted a solitary fire glowing in the dark sea of the steppe.",
    );

    var p5 = PageNode(
      text:
          "In the rare times the moonlight was visible, it was possible to glimpse the silhouettes of people and horses. Two were sleeping on the ground facing each other. A third was sitting closer to the fire, leaning against a short spear and, seemingly, also sleeping. It was harder to make out the horses as they slept on the other side of the fire, but there appeared to be at least five of them.",
    );

    var p6 = PageNode(
      text:
          "In the rare times the moonlight was visible, it was possible to glimpse the silhouettes of people and horses. Two were sleeping on the ground facing each other. A third was sitting closer to the fire, leaning against a short spear and, seemingly, also sleeping. It was harder to make out the horses as they slept on the other side of the fire, but there appeared to be at least five of them.",
    );

    return Page(
      nodes: [p1, p2, p3, p4, p5, p6],
      endType: EndType.ALIVE,
    );
  }
}

class PageNext {
  String text;
  Page nextPage;

  PageNext({this.text, this.nextPage});

  static fromMap(Map<String, dynamic> map) {
    return PageNext(text: map["text"], nextPage: Page.fromMap(map["nextPage"]));
  }

  toMap() {
    return {
      "text": text,
      "nextPage": nextPage.toMap(),
    };
  }
}

enum EndType { DEAD, ALIVE }

String endTypeToString(EndType endType) {
  switch (endType) {
    case EndType.ALIVE:
      return "ALIVE";
    case EndType.DEAD:
      return "DEAD";
    default:
      return null;
  }
}

EndType endTypeFromString(String input) {
  switch (input) {
    case "ALIVE":
      return EndType.ALIVE;
    case "DEAD":
      return EndType.DEAD;
    default:
      return null;
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

  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "imageType": imageTypeToString(imageType),
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return PageNode(
      imageType: imageTypeFromString(map["imageType"]),
      text: map["text"],
    );
  }
}
