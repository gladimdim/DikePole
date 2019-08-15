import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/story/Story.dart';
import 'package:locadeserta_web/story/widgets/passage_continue_builder_view.dart';
import 'package:tuple/tuple.dart';

class StoryBuilder {
  String title;
  String description;
  List<String> authors;
  int count = 0;

  List<PassageBuilderBase> _passages = [];


  StoryBuilder({this.title, this.description, this.authors});

  void addPassage(PassageBuilderBase passage) {
    passage.id = count++;
    print("passage: ${passage.id}");
    _passages.add(passage);
  }

  List<PassageBuilderBase> getPassages() => _passages;

  List<int> getAllIds() {
    return _passages.map((passage) => passage.id).toList();
  }

  Story toModel() {
    return Story(
      title: title,
      description: description,
      authors: authors,
      passages: _passages.map((passage) => passage.toModel()).toList()
    );
  }
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

  @override
  Widget toWidget(StoryBuilder storyBuilder) {
    return PassageContinueBuilderView(
      passage: this, storyBuilder: storyBuilder,
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
          type: PassageTypes.Random,
        );

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
          type: PassageTypes.Option,
        );

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

  Widget toWidget(StoryBuilder storyBuilder) {
    return Text(passageTypeToString(type));
  }

  PassageBase toModel();
}

PassageBuilderBase passageBuilderFromType(PassageTypes type) {
  switch (type) {
    case PassageTypes.Continue: return PassageBuilderContinue();
    case PassageTypes.Option: return PassageBuilderOption();
    case PassageTypes.Random: return PassageBuilderRandom();
    default: throw "PassageType $type is not recognized";
  }
}
