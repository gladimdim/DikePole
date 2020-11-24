import 'dart:io';

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:nanoid/async/nanoid.dart';
import 'package:server/static/generate_html.dart';

int port = 9093;
var rootFolder = "data";
var passedStoriesFolder = "passed_stories";
run() async {
  var app = Angel();
  var http = AngelHttp(app);
  await http.startServer('localhost', port);
  // await http.startServer('localhost', port);
  print("Server started at port $port");
  app.get('/', (req, res) => res.write('Hello, world!'));

  app.post("/post_story", (req, res) async {
    await req.parseBody();
    var body = req.bodyAsMap;
    Story story;
    try {
      story = Story.fromJson(body);
    } catch (e) {
      throw AngelHttpException.notProcessable();
    }

    var markdown = story.toMarkdownString();
    var id = await nanoid();
    var file = File("$rootFolder/$passedStoriesFolder/$id.md");
    await file.writeAsString(markdown);
    res.write(id);
  });

  app.get("/passed_stories/:id", (req, res) async {
    var id = req.params["id"];
    var markdown =
        await File("$rootFolder/$passedStoriesFolder/$id.md").readAsString();
    var indexHtml = generateHtml(markdown);
    res.headers.addAll({"Content-Type": "text/html; charset=utf-8"});
    res.write(indexHtml);
  });
}
