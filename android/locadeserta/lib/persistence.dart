import 'dart:io';
import 'dart:async';
import "package:locadeserta/story_bridge.dart";
import 'package:path_provider/path_provider.dart';

class Persistence {
  final StoryBridge bridge;
  Persistence ({this.bridge});

  Future<File> getStoryFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path;
    return File("$path/$filename.inky.json");
  }
  Future<void> saveStoryToFile(String filename) async {
    String newState = await this.bridge.getStateJson();
    File file = await getStoryFile(filename);
    await file.writeAsString(newState);
  }

  Future<String> getStoryFromFile(String filename) async {
    File persist = await getStoryFile(filename);
    String result = await persist.readAsString();
    return result;
  }
}