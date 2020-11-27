import 'dart:convert';

import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:http/http.dart' as http;

// var url = "https://dikepole.locadeserta.com";
var url = "http://localhost:9093";

Future<String> uploadStoryToServer(Story story) async {
  var result = await http.post(
    "$url/post_story",
    body: jsonEncode(story.toStateJson()),
    headers: {"content-type": "application/json"},
  );
  return result.body;
}

Future<List> getPurgatoryStories() async {
  var result = await http.get("$url/purgatory");
  return jsonDecode(result.body);
}

Future<Map> getPurgatoryStoryByName(String name) async {
  var result = await http.get("$url/purgatory/$name");
  return jsonDecode(result.body);
}

Future<bool> uploadStoryToPurgatoryCatalog(Story story) async {
  var result = await http.post(
    "$url/purgatory/${story.title}",
    body: jsonEncode(story.toJson()),
    headers: {"content-type": "application/json"},
  );
  return result.statusCode == 200;
}
