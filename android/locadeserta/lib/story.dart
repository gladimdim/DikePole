import 'dart:core';
import 'package:flutter/services.dart';
import 'dart:async';

class Story {
  static const platform = const MethodChannel('gladimdim.locadeserta/Ink');

  Future<String> getContinue() async {
    String text;
    try {
      await Story.initStory();
      final currentText = await platform.invokeMethod("Continue");
      text = currentText;
    } on PlatformException {
      text = "test";
    }
    return text;
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

