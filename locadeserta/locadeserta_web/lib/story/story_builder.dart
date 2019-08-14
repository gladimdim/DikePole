import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/story/Story.dart';
import 'package:tuple/tuple.dart';

class StoryBuilder {
  String title;
  String description;
  String authors;

  List passages;
}

class PassageBuilderContinue extends PassageBuilderBase {
  int next;
  String text;
  int id;
  String imagePath;

  PassageBuilderContinue({this.text, this.next, this.imagePath, this.id})
      : super(
            text: text,
            id: id,
            imagePath: imagePath,
            type: PassageTypes.Continue);

  PassageContinue toModel() {
    return PassageContinue(
      id: id,
      text: text,
      imagePath: imagePath,
      next: next,
    );
  }
}

class PassageBuilderRandom extends PassageBuilderBase {
  String text;
  int id;
  String imagePath;
  List<int> next;

  PassageBuilderRandom({this.text, this.next, this.imagePath, this.id})
      : super(
            text: text,
            id: id,
            imagePath: imagePath,
            type: PassageTypes.Random);

  PassageRandom toModel() {
    return PassageRandom(
      id: id,
      text: text,
      imagePath: imagePath,
      next: next,
    );
  }
}

class PassageBuilderOption extends PassageBuilderBase {
  String text;
  int id;
  String imagePath;
  List<Tuple2<int, String>> next;

  PassageBuilderOption({this.text, this.next, this.imagePath, this.id})
      : super(
            text: text,
            id: id,
            imagePath: imagePath,
            type: PassageTypes.Option);

  PassageOption toModel() {
    return PassageOption(
      id: id,
      text: text,
      imagePath: imagePath,
      options: next,
    );
  }
}

abstract class PassageBuilderBase {
  String text;
  String imagePath;
  int id;
  PassageTypes type;

  PassageBuilderBase({this.text, this.imagePath, this.id, @required this.type});

  Widget toWidget() {
    return Text(text);
  }

  PassageBase toModel();
}
