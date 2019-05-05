import 'dart:io';
import 'dart:async';
import "package:locadeserta/models/story_bridge.dart";
import 'package:path_provider/path_provider.dart';

class Persistence {
  final StoryBridge bridge;
  Persistence ({this.bridge});

  Future<File> getStoryFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path;
    return File("$path/$filename.inky.json");
  }
  Future<String> getStateJson() async {
    return await this.bridge.getStateJson();
  }

  Future<String> getStoryFromFile(String filename) async {
    File persist = await getStoryFile(filename);
    String result = await persist.readAsString();
    return result;
  }
}