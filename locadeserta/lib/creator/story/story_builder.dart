import 'package:flutter/material.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/creator/story/widgets/passage_builder_view.dart';
import 'package:locadeserta/creator/utils/utils.dart';
import 'package:locadeserta/models/background_image.dart';
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

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "passages": getPassages().map((passage) => passage.toMap()).toList(),
      "authors": authors,
    };
  }

  static StoryBuilder fromStory(Story story) {
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

  void removePassage(PassageBuilderBase passage) {
    _passages.remove(passage);
  }
}

class PassageBuilderContinue extends PassageBuilderBase {
  int next;
  String text;
  int id;
  ImageType imageType;

  PassageBuilderContinue({this.text, this.next, this.imageType = ImageType.BULRUSH, this.id})
      : super(
            text: text,
            id: id,
            imageType: imageType,
            type: PassageTypes.Continue);

  PassageContinue toModel() {
    return PassageContinue(
      id: id,
      text: text,
      imageType: imageType,
      next: next,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "text": "text",
      "imageType": imageType,
      "next": next
    };
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
      imageType: base.imageType,
      next: base.getNexts(),
      text: base.text,
    );
  }
}

class PassageBuilderOption extends PassageBuilderBase {
  String text;
  int id;
  ImageType imageType;
  List<NextOption> next = [];

  PassageBuilderOption({this.text, this.next, this.imageType = ImageType.BOAT, this.id})
      : super(
          text: text,
          id: id,
          imageType: imageType,
          type: PassageTypes.Option,
        );

  PassageOption toModel() {
    return PassageOption(
      id: id,
      text: text,
      imageType: imageType,
      options: next,
    );
  }


  static PassageBuilderOption fromStoryPassage(PassageBase base) {
    return PassageBuilderOption(
      id: base.id,
      imageType: base.imageType,
      next: base.getNexts(),
      text: base.text,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "text": "text",
      "imageType": imageType,
      "next": next.map((next) => {"target": next.target, "text": next.text}).toList(),
    };
  }

  @override
  Widget toEditWidget(StoryBuilder storyBuilder) {
    return PassageOptionBuilderView(
      storyBuilder: storyBuilder,
      passage: this,
    );
  }
}

abstract class PassageBuilderBase {
  String text;
  ImageType imageType;
  int id;
  PassageTypes type;

  PassageBuilderBase({this.text, this.imageType = ImageType.BOAT, this.id, @required this.type});

  Widget toWidget() {
    return Row(
      children: [
        Image(
          image: BackgroundImage.getAssetImageForType(imageType),
          width: 48,
          height: 48,
          fit: BoxFit.fill,
        ),
        Text(firstNCharsFromString(text, 35), overflow: TextOverflow.ellipsis,),
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
      default:
        throw "PassageType ${base.type} is not recognized";
    }
  }

  Map<String, dynamic> toMap();
}

PassageBuilderBase passageBuilderFromType(PassageTypes type) {
  var defaultText = "";
  switch (type) {
    case PassageTypes.Continue:
      return PassageBuilderContinue(text: defaultText);
    case PassageTypes.Option:
      return PassageBuilderOption(text: defaultText, next: List());
    default:
      throw "PassageType $type is not recognized";
  }
}
