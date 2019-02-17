import 'dart:core';
import 'package:flutter/services.dart';
import 'dart:async';

class Story {
  final String currentText;
  final List<String> currentChoices;
  final bool canContinue;

  Story({this.currentText, this.currentChoices, this.canContinue});
}

class StoryBridge {
  static const platform = const MethodChannel('gladimdim.locadeserta/Ink');
  Story story;

  Future<void> refreshStory() async {
    String currentText;
    List<String> choices;
    bool canContinue;
    try {
      currentText = await platform.invokeMethod("getCurrentText");
      var temp = await platform.invokeMethod("getCurrentChoices");
      choices = new List.from(temp);
      canContinue = await platform.invokeMethod("canContinue");
    } on PlatformException {
      print("Error");
    }
    story = new Story(
        currentText: currentText,
        currentChoices: choices,
        canContinue: canContinue);
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

  Future<Story> tick() async {
    await StoryBridge.initStory();
    if (story == null) {
      story = await doContinue();
    }
    return story;
  }

  static Future<void> initStory() async {
    try {
      final inkyText = await rootBundle.loadString("stories/locadeserta.ink.json");
      final result = await platform.invokeMethod("Init", {"text": inkyText});
    } on PlatformException {
      var text = "test";
    }
  }
}
