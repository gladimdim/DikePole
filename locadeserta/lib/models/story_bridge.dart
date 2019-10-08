import 'dart:core';
import 'package:flutter/services.dart';
import 'package:locadeserta/models/background_image.dart';
import 'dart:async';

import 'package:locadeserta/models/story_history.dart';

class Story {
  final String currentText;
  final List<String> currentChoices;
  final bool canContinue;
  final List<String> inventory;
  final List<String> currentTags;
  final bool theEnd;
  final bool toBeContinued;
  StoryHistory storyHistory;

  Story({
    this.currentText,
    this.currentChoices,
    this.canContinue,
    this.inventory,
    this.currentTags,
    this.theEnd = false,
    this.toBeContinued = false,
    this.storyHistory,
  });
}

class StoryBridge {
  final StreamController<Story> streamStory = StreamController<Story>();
  static const platform = const MethodChannel('gladimdim.locadeserta/Ink');
  Story story;
  StoryHistory savedStoryHistory;

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

    var history;
    if (savedStoryHistory == null) {
      if (story == null) {
        history = StoryHistory([]);
      } else {
        history = story.storyHistory;
      }
    } else {
      history = savedStoryHistory;
      savedStoryHistory = null;
    }

    story = new Story(
      currentText: currentText,
      currentChoices: choices,
      canContinue: canContinue,
      currentTags: currentTags,
      inventory: [],
      toBeContinued: toBeContinued,
      theEnd: theEnd,
      storyHistory: history,
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
    await _doContinue();
    if (story != null) {
      if (!story.storyHistory.isEmpty() &&
          story.storyHistory.getLast().value != story.currentText) {
        _addCurrentPassage();
      }
    }
  }

  _createPassage(String text, ImageType type) {
    BackgroundImage.nextRandomForType(type);
    var randomImage = BackgroundImage.getRandomImageForType(type);

    return story.canContinue
        ? HistoryItemText(text)
        : HistoryItemImage([
            randomImage.getImagePathColored(),
            randomImage.getImagePath(),
          ], type);
  }

  ImageType createImageType() {
    print("current tags: ${story.currentTags}");
    var currentTags = story.currentTags;
    if (currentTags != null && currentTags.isNotEmpty) {
      return BackgroundImage.imageTypeFromCurrentTags(currentTags);
    } else {
      return ImageType.FOREST;
    }
  }

  Future<void> chooseChoiceIndex(int i, passage) async {
    story.storyHistory.addItem(HistoryItemText(story.currentChoices[i]));
    try {
      await platform.invokeMethod("chooseChoiceIndex", i);
      await _doContinue();
      await _refreshStory();
      _addCurrentPassage();
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

  String getHistoryJson() {
    return this.story.storyHistory.toString();
  }

  Future<void> initStory(
      {String storyJson, String state, String historyJson}) async {
    try {
      if (historyJson != null) {
        savedStoryHistory = StoryHistory.fromString(historyJson);
      }
    } catch (e) {
      print(
          "Failed at parsing history, continuing without initialization of it: ${e.toString()}");
    }
    try {
      await platform.invokeMethod("Init", storyJson);
      if (state != null) {
        await platform.invokeMethod("restoreState", {"text": state});
      }
      await _doContinue();
      story.storyHistory
          .addItem(_createPassage(story.currentText, createImageType()));
      if (!story.canContinue) {
        story.storyHistory.addItem(HistoryItemText(story.currentText));
      }
    } catch (e) {
      print("Failed at initStory with error: ${e.toString()}");
    }
  }

  Future<void> resetState() async {
    story.storyHistory.clear();
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
    story.storyHistory.addItem(
      _createPassage(
        story.currentText,
        createImageType(),
      ),
    );
  }

  dispose() {
    streamStory.close();
  }
}
