import 'dart:io';

import 'package:server/constants.dart';
import 'package:server/static/generate_story_html.dart';

Future<String> generateCatalogStoryBodyHtml(
    String name, String fileName) async {
  var file = File("$DIR_ROOT/$DIR_BUILT_IN_STORIES/$name/$fileName");
  var exists = await file.exists();
  if (exists) {
    var content = await file.readAsString();
    return generateStoryHtml(content);
  } else {
    throw FileSystemEntityType.notFound;
  }
}
