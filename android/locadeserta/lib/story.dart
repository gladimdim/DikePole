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

  Future<Story> doContinue() async {
    String currentText;
    List<String> choices;
    bool canContinue;
    try {
      await StoryBridge.initStory();
      currentText = await platform.invokeMethod("Continue");
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
    return story;
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
      final inkyText = await rootBundle.loadString("stories/inky.json");
      final result = await platform.invokeMethod("Init", {"text": inkyText});
    } on PlatformException {
      var text = "test";
    }
  }
}
