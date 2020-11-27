import 'dart:io';

import 'package:server/constants.dart';
import 'package:server/dynamic/filesystem.dart';
import 'package:server/static/generate_head.dart';

Future<String> generateCatalogStoryHtml(String name) async {
  var listOfStories = await getEntriesInDirOfType<File>(
      "$DIR_ROOT/$DIR_BUILT_IN_STORIES/$name");

  var ul = "<ul>\n";
  listOfStories.sort();
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
