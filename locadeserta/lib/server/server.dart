import 'dart:convert';

import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:http/http.dart' as http;

var url = "http://localhost:9093";

Future<String> uploadStoryToServer(Story story) async {
  var result = await http.post(
    "$url/post_story",
    body: jsonEncode(story.toStateJson()),
    headers: {"content-type": "application/json"},
  );
  return result.body;
}