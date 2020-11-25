import 'dart:io';

import 'package:server/generator/story_generator.dart';
import 'package:server/server.dart';
import 'package:server/static/generate_head.dart';

Future<String> generateCatalogStoryHtml(String name) async {
  var folder = Directory("$rootFolder/$builtinStories/$name");
  var listOfStories = [];
  await for (FileSystemEntity f in folder.list()) {
    if (f is File) {
      var folderName = f.path.split("$rootFolder/$builtinStories/$name/")[1];
      listOfStories.add(folderName);
    }
  }

  var ul = "<ul>\n";
  listOfStories.forEach((element) {
    ul = ul +
        """
          <li><a href='$name/$element'>$name/$element</a></li>
        """;
  });

  return """
        <!doctype html>
        <html>
       ${generateHead()}
        <body>
        <h2>Всі варіанти проходжень інтерактивних історій '$name' з всесвіту <a href="https://locadeserta.com/">Дикого Поля</a></div></h2>
         <h4>$ul</h4>
        </body>
        </html>
    """;
}
