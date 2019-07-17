import 'dart:core';
import 'package:flutter/services.dart';
import 'package:locadeserta/models/background_image.dart';
import 'dart:async';

import 'package:locadeserta/models/passage_item.dart';

class Story {
  final String currentText;
  final List<String> currentChoices;
  final bool canContinue;
  final List<String> inventory;
  final List<String> currentTags;
  final bool theEnd;
  final bool toBeContinued;
  final PassageItem passage;
  final List<PassageItem> history;

  Story({
    this.currentText,
    this.currentChoices,
    this.canContinue,
    this.inventory,
    this.currentTags,
    this.theEnd = false,
    this.toBeContinued = false,
    this.passage,
    this.history = const [],
  });
}

class StoryBridge {
  final StreamController<Story> streamStory = StreamController<Story>();
  static const platform = const MethodChannel('gladimdim.locadeserta/Ink');
  Story story;

  Future<void> _refreshStory() async {
    String currentText;
    List<String> choices;
    bool canContinue;
    List<String> currentTags;
//    List<String> inventory;
    try {
      currentText = await platform.invokeMethod("getCurrentText");
      var temp = await platform.invokeMethod("getCurrentChoices");
      if (temp == null) {
        temp = [];
      }
      choices = new List.from(temp);
      canContinue = await platform.invokeMethod("canContinue");
      var dynamicTags = await platform.invokeMethod("getCurrentTags");
      if (dynamicTags == null) {
        dynamicTags = [];
      }
      currentTags = List.from(dynamicTags);

//      var tempInventory = await platform.invokeMethod("getInventory");
//      inventory = List.from(tempInventory);
    } catch (e) {
      print("Error: ${e.toString()}");
    }

    bool toBeContinued =
        (currentTags.isNotEmpty && currentTags[0] == "image tobecontinued");
    bool theEnd = (currentTags.isNotEmpty && currentTags[0] == "image theend");

    story = new Story(
      currentText: currentText,
      currentChoices: choices,
      canContinue: canContinue,
      currentTags: currentTags,
      inventory: [],
      toBeContinued: toBeContinued,
      theEnd: theEnd,
      history: story == null ? [] : story.history,
    );

    streamStory.sink.add(story);
  }

  Future<void> _doContinue() async {
    try {
      await platform.invokeMethod("Continue");
    } catch (e) {
      print("Error, could not continue: ${e.toString()}");
    }

    await _refreshStory();
  }

  Future<void> doContinue() async {
    if (story != null) {
      if (story.history.isNotEmpty && story.history.last.value != story.currentText) {
        _addCurrentPassage();
      }
    }
    await _doContinue();
  }

  PassageItem _createPassage(String text, ImageType type) {
    return story.canContinue
        ? PassageItem(type: PassageTypes.TEXT, value: text)
        : PassageItem(type: PassageTypes.IMAGE, value: type);
  }

  ImageType _createImageType(Story story) {
    print("current tags: ${story.currentTags}");
    var currentTags = story.currentTags;
    if (currentTags != null && currentTags.isNotEmpty) {
      return BackgroundImage.imageTypeFromCurrentTags(currentTags);
    } else {
      return ImageType.FOREST;
    }
  }

  Future<void> chooseChoiceIndex(int i, ImageType imageType) async {
    BackgroundImage.nextRandomForType(
      imageType,
    );

    story.history.add(
      PassageItem(type: PassageTypes.IMAGE, value: imageType),
    );

    story.history.add(
        PassageItem(type: PassageTypes.TEXT, value: story.currentChoices[i]));
    try {
      await platform.invokeMethod("chooseChoiceIndex", i);
      await _doContinue();
      await _refreshStory();
    } catch (e) {
      throw e;
    }
  }

  Future<String> getStateJson() async {
    try {
      String newState = await platform.invokeMethod("saveState");
      return newState;
    } catch (e) {
      throw e;
    }
  }

  Future<void> initStory({String storyJson, String state}) async {
    try {
      await platform.invokeMethod("Init", storyJson);
      if (state != null) {
        await platform.invokeMethod("restoreState", {"text": state});
      }
      await _doContinue();
      story.history
          .add(_createPassage(story.currentText, _createImageType(story)));
      if (!story.canContinue) {
        story.history.add(
            PassageItem(type: PassageTypes.TEXT, value: story.currentText));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> resetState() async {
    story.history.clear();
    try {
      await platform.invokeMethod("resetState");
    } catch (e) {
      print("resetState failed with error : ${e.toString()}");
    }
    await _doContinue();
    _addCurrentPassage();
  }

  Future<List<String>> getInventory() async {
    try {
      final list = await platform.invokeMethod("getInventory");
      return list;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  void _addCurrentPassage() {
    story.history.add(
      _createPassage(
        story.currentText,
        _createImageType(story),
      ),
    );
  }
}
