import 'dart:io';

import 'package:server/generator/story_generator.dart';
import 'package:server/server.dart';
import 'package:server/static/generate_head.dart';

Future<String> generateCatalogHtml() async {
  var folder = Directory("$rootFolder/$builtinStories");
  var listOfStories = [];
  await for (FileSystemEntity f in folder.list()) {
    if (f is Directory) {
      var folderName = f.path.split("$rootFolder/$builtinStories\\")[1];
      listOfStories.add(folderName);
    }
  }

  var ul = "<ul>\n";
  listOfStories.forEach((element) {
    ul = ul +
        """
          <li>$element</li>
        """;
  });

  ul = ul + "\n</ul>";

  return """
        <!doctype html>
        <html>
       ${generateHead()}
        <body>
         $ul
        </body>
        </html>
    """;
}
