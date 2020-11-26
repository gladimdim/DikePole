import 'dart:convert';
import 'dart:io';

import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:server/constants.dart';
import 'package:server/dynamic/filesystem.dart';

Future<List> generatePurgatoryList() async {
  var files = await getEntriesInDirOfType<File>("$DIR_ROOT/$DIR_PURGATORY");
  return files;
}

Future saveStoryToPurgatory(Story story) async {
  var file = File("$DIR_ROOT/$DIR_PURGATORY/${story.title}");
  await file.writeAsString(jsonEncode(story.toJson()));
}
