import 'dart:io';

import 'package:server/generator/story_generator.dart';
import 'package:server/server.dart';
import 'package:server/static/generate_story_html.dart';

Future<String> generateCatalogStoryBodyHtml(
    String name, String fileName) async {
  var file = File("$rootFolder/$builtinStories/$name/$fileName");
  var exists = await file.exists();
  if (exists) {
    var content = await file.readAsString();
    return generateStoryHtml(content);
  } else {
    throw FileSystemEntityType.notFound;
  }
}
