import 'dart:convert';

import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:http/http.dart' as http;

// var url = "https://dikepole.locadeserta.com";
var url = "http://localhost:9093";

Future<String> uploadStoryToServer(Story story) async {
  try {
    var result = await http.post(Uri.http(url, "/post_story"),
      body: jsonEncode(story.toStateJson()),
      headers: {"content-type": "application/json"},
    );
    return result.body;
  } catch (exception) {
    print("Error while calling upload story: $exception");
  }
}

Future<List> getPurgatoryStories() async {
  var result = await http.get(Uri.https(url, "/purgatory"));
  return jsonDecode(result.body);
}

Future<Map> getPurgatoryStoryByName(String name) async {
  var result = await http.get(Uri.https(url, "purgatory/$name"));
  return jsonDecode(result.body);
}

Future<bool> uploadStoryToPurgatoryCatalog(Story story) async {
  var result = await http.post(
    Uri.https(url, "/purgatory/${story.title}"),
    body: jsonEncode(story.toJson()),
    headers: {"content-type": "application/json"},
  );
  return result.statusCode == 200;
}
