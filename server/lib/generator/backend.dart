import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List> fetchStories() async {
  var response = await http
      .get("https://locadeserta.com/game/assets/assets/story_catalog.json");
  List json = jsonDecode(response.body)["stories"];
  return json;
}

Future<Map> fetchStory(String url) async {
  var response = await http.get(url);
  var json = jsonDecode(response.body);
  return json;
}
