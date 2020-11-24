import 'dart:io';

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:nanoid/async/nanoid.dart';

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
  // app.fallback(dynamicCors((req, res) {
  //   return CorsOptions(
  //     origin: [
  //       req.headers.value('origin') ?? 'http://locadeserta.com',
  //       RegExp(r'\.com$'),
  //     ],
  //   );
  // }));

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
    var indexHtml = """
        <!doctype html>
        <html>
        <head>
          <meta charset="utf-8"/>
          <title>Інтерактивна історія. Дике Поле.</title>
          <meta property="twitter:card" content="summary_large_image">
          <meta property="twitter:url" content="https://locadeserta.com">
          <meta property="twitter:title" content="Інтерактивна історія. Дике Поле. Loca Deserta.">
          <meta property="twitter:description" content="Loca Deserta: Дике Поле. Інтерактивні історії про Великий Луг. Створий свою власну історію">
          <meta property="twitter:image" content="https://locadeserta.com/game/assets/images/background/landing/5.jpg">
        </head>
        <body>
          <div>Дике Поле: Козацька Доля. Більше історій тут: <a href="https://locadeserta.com/">Всесвіт Дикого Поля</a></div>
          <div id="content"></div>
          <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
          <script>
            document.getElementById('content').innerHTML =
              marked(`$markdown`);
          </script>
        </body>
        </html>
    """;

    res.headers.addAll({"Content-Type": "text/html; charset=utf-8"});
    res.write(indexHtml);
  });
}
