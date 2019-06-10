import 'dart:core';
import 'package:flutter/services.dart';
import 'dart:async';

class Story {
  final String currentText;
  final List<String> currentChoices;
  final bool canContinue;
  final List<String> inventory;
  final List<String> currentTags;

  Story(
      {this.currentText,
      this.currentChoices,
      this.canContinue,
      this.inventory,
      this.currentTags});
}

class StoryBridge {
  final StreamController<Story> streamStory = StreamController<Story>();
  static const platform = const MethodChannel('gladimdim.locadeserta/Ink');
  Story story;

  void playSound(String fileName) async {
    try {
      await platform.invokeMethod("playSound", {"fileName": fileName});
    } on PlatformException {
      print("Error");
    }
  }

  Future<void> _refreshStory() async {
    String currentText;
    List<String> choices;
    bool canContinue;
    List<String> currentTags;
    List<String> inventory;
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
    story = new Story(
      currentText: currentText,
      currentChoices: choices,
      canContinue: canContinue,
      currentTags: currentTags,
      inventory: [],
    );
    streamStory.sink.add(story);
  }

  Future<void> doContinue() async {
    try {
      await platform.invokeMethod("Continue");
    } on PlatformException {
      print("Error");
    }
    await _refreshStory();
  }

  Future<void> chooseChoiceIndex(int i) async {
    try {
      await platform.invokeMethod("chooseChoiceIndex", i);
      await doContinue();
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
    if (storyJson == null) {
      try {
        final inkyText =
            await rootBundle.loadString("stories/locadeserta.ink.json");
        await platform.invokeMethod("Init", inkyText);
        if (state != null) {
          await platform.invokeMethod("restoreState", {"text": state});
          await doContinue();
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        await platform.invokeMethod("Init", storyJson);
        if (state != null) {
          await platform.invokeMethod("restoreState", {"text": state});
        }
        await doContinue();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> resetStory() async {
    await this.initStory();
    await this._refreshStory();
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
}
