import 'dart:io';

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:nanoid/async/nanoid.dart';
import 'package:server/constants.dart';
import 'package:server/dynamic/purgatory.dart';
import 'package:server/static/generate_404.dart';
import 'package:server/static/generate_catalog.dart';
import 'package:server/static/generate_catalog_story_body_html.dart';
import 'package:server/static/generate_catalog_story_html.dart';
import 'package:server/static/generate_story_html.dart';

int port = 9093;

run() async {
  var app = Angel();
  var http = AngelHttp(app);
  await http.startServer('localhost', port);
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

    var markdown = story.toMarkdownString(imagePrefix);
    var id = await nanoid();
    var file = File("$DIR_ROOT/$DIR_PASSED_STORIES/$id.md");
    await file.writeAsString(markdown);
    res.write(id);
  });

  app.get("/passed_stories/:id", (req, res) async {
    var id = req.params["id"];
    res.headers.addAll({"Content-Type": "text/html; charset=utf-8"});
    try {
      var markdown =
          await File("$DIR_ROOT/$DIR_PASSED_STORIES/$id.md").readAsString();
      var indexHtml = generateStoryHtml(markdown);
      res.write(indexHtml);
    } catch (e) {
      res.write(generate404Response());
    }
  });

  app.get(PATH_PURGATORY, (req, res) async {
    res.headers.addAll({"Content-Type": "application/json; charset=utf-8"});
    var response = await generatePurgatoryList();
    res.write(response);
  });

  app.get(PATH_CATALOG, (req, res) async {
    var html = await generateCatalogHtml();

    res.headers.addAll({"Content-Type": "text/html; charset=utf-8"});
    res.write(html);
  });

  app.get("$PATH_CATALOG/:name", (req, res) async {
    var name = req.params["name"];
    res.headers.addAll({"Content-Type": "text/html; charset=utf-8"});
    var html = await generateCatalogStoryHtml(name);
    res.write(html);
  });

  app.get("$PATH_CATALOG/:name/:id", (req, res) async {
    var name = req.params["name"];
    var id = req.params["id"];

    res.headers.addAll({"Content-Type": "text/html; charset=utf-8"});
    var html = await generateCatalogStoryBodyHtml(name, id);
    res.write(html);
  });
}
