import 'dart:core';
import 'package:flutter/services.dart';
import 'dart:async';

class Story {
  final String currentText;
  final List<String> currentChoices;
  final bool canContinue;
  final List<String> currentTags;

  Story(
      {this.currentText,
      this.currentChoices,
      this.canContinue,
      this.currentTags});
}

class StoryBridge {
  static const platform = const MethodChannel('gladimdim.locadeserta/Ink');
  Story story;

  void playSound(String fileName) async {
    try {
      await platform.invokeMethod("playSound", {"fileName": fileName});
    } on PlatformException {
      print("Error");
    }
  }

  Future<void> refreshStory() async {
    String currentText;
    List<String> choices;
    bool canContinue;
    List<String> currentTags;
    try {
      currentText = await platform.invokeMethod("getCurrentText");
      var temp = await platform.invokeMethod("getCurrentChoices");
      choices = new List.from(temp);
      canContinue = await platform.invokeMethod("canContinue");
      var dynamicTags = await platform.invokeMethod("getCurrentTags");
      currentTags = List.from(dynamicTags);
    } on PlatformException {
      print("Error");
    }
    story = new Story(
      currentText: currentText,
      currentChoices: choices,
      canContinue: canContinue,
      currentTags: currentTags,
    );
  }

  Future<Story> doContinue() async {
    try {
      await platform.invokeMethod("Continue");
    } on PlatformException {
      print("Error");
    }
    await refreshStory();
    return story;
  }

  Future<Story> chooseChoiceIndex(int i) async {
    try {
      await platform.invokeMethod("chooseChoiceIndex", {"index": i});
      await doContinue();
      await refreshStory();
      return story;
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

  Future<Story> tick() async {
    if (story == null) {
      story = await doContinue();
    }
    return story;
  }

  Future<void> initStory({String state}) async {
    try {
      final inkyText =
          await rootBundle.loadString("stories/locadeserta.ink.json");
      await platform.invokeMethod("Init", {"text": inkyText});
      if (state != null) {
        await platform.invokeMethod("restoreState", {"text": state});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> resetStory() async {
    await this.initStory();
    await this.refreshStory();
  }
}
