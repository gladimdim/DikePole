import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/story/Story.dart';
import 'package:locadeserta_web/story/widgets/passage_builder_view.dart';
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
        passages: _passages.map((passage) => passage.toModel()).toList());
  }

  static fromStory(Story story) {
    var sb = StoryBuilder(
      title: story.title,
      description: story.description,
      authors: story.authors,
    );

    story.passages.forEach((passage) {
      sb.addPassage(PassageBuilderBase.fromStoryPassage(passage));
    });

    return sb;
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
  Widget toEditWidget(StoryBuilder storyBuilder) {
    return PassageContinueBuilderView(
      passage: this,
      storyBuilder: storyBuilder,
    );
  }

  static PassageBuilderContinue fromStoryPassage(PassageBase base) {
    return PassageBuilderContinue(
      id: base.id,
      imagePath: base.imagePath,
      next: base.getNexts(),
      text: base.text,
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

  Widget toEditWidget(StoryBuilder storyBuilder) {
    return PassageRandomBuilderView(
      passage: this,
      storyBuilder: storyBuilder,
    );
  }

  static PassageBuilderRandom fromStoryPassage(PassageBase base) {
    return PassageBuilderRandom(
      id: base.id,
      imagePath: base.imagePath,
      next: base.getNexts(),
      text: base.text,
    );
  }
}

class PassageBuilderOption extends PassageBuilderBase {
  String text;
  int id;
  String imagePath;
  List<Tuple2<int, String>> next = [];

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

  static PassageBuilderOption fromStoryPassage(PassageBase base) {
    return PassageBuilderOption(
      id: base.id,
      imagePath: base.imagePath,
      next: base.getNexts(),
      text: base.text,
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
    return Row(
      children: [
        Image(
          image: AssetImage(this.imagePath),
          width: 48,
          height: 48,
          fit: BoxFit.fill,
        ),
        Text(text, overflow: TextOverflow.ellipsis,),
      ],
    );
  }

  Widget toEditWidget(StoryBuilder storyBuilder) {
    return Text(passageTypeToString(type));
  }

  PassageBase toModel();

  static fromStoryPassage(PassageBase base) {
    switch (base.type) {
      case PassageTypes.Continue:
        return PassageBuilderContinue.fromStoryPassage(base);
      case PassageTypes.Option:
        return PassageBuilderOption.fromStoryPassage(base);
      case PassageTypes.Random:
        return PassageBuilderRandom.fromStoryPassage(base);
      default:
        throw "PassageType ${base.type} is not recognized";
    }
  }
}

PassageBuilderBase passageBuilderFromType(PassageTypes type) {
  var defaultText = "<<Enter passage text>>";
  switch (type) {
    case PassageTypes.Continue:
      return PassageBuilderContinue(text: defaultText);
    case PassageTypes.Option:
      return PassageBuilderOption(text: defaultText, next: List());
    case PassageTypes.Random:
      return PassageBuilderRandom(text: defaultText, next: List());
    default:
      throw "PassageType $type is not recognized";
  }
}
