import 'dart:convert';
import 'dart:io';

import 'package:angel_cors/angel_cors.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:nanoid/async/nanoid.dart';

int port = 9093;

run() async {
  var app = Angel();
  var http = AngelHttp(app);
  // await http.startServer('134.122.79.137', port);
  await http.startServer('localhost', port);
  print("Server started at port $port");
  app.get('/', (req, res) => res.write('Hello, world!'));
  app.fallback(dynamicCors((req, res) {
    return CorsOptions(
      origin: [
        req.headers.value('origin') ?? 'http://locadeserta.com',
        RegExp(r'\.com$'),
      ],
    );
  }));

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
    var file = File("data/passed_stories/$id.md");
    await file.writeAsString(markdown);
    res.write(id);
  });

  app.get("/family_dashboard/gladkyi", (req, res) async {
    var state = await File("data/states/gladkyi.json").readAsString();
    var response = jsonEncode(state);
    res.headers.addAll({"Content-Type": "application/json; charset=utf-8"});
    res.write(state);
  });
}
