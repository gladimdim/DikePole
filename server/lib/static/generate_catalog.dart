import 'dart:io';

import 'package:server/constants.dart';
import 'package:server/dynamic/filesystem.dart';
import 'package:server/static/generate_head.dart';

Future<String> generateCatalogHtml() async {
  var listOfStories =
      await getEntriesInDirOfType<Directory>("$DIR_ROOT/$DIR_BUILT_IN_STORIES");

  var ul = "<ul>\n";
  listOfStories.forEach((element) {
    ul = ul +
        """
          <li><a href='$PATH_CATALOG/$element'>$element</a></li>
        """;
  });

  ul = ul + "\n</ul>";

  return """
        <!doctype html>
        <html>
       ${generateHead()}
        <body>
        <h1>Каталог всіх опублікованих історій з всесвіту <a href="https://locadeserta.com/">Дикого Поля</a></div></h1>
         <h3>$ul</h3>
        </body>
        </html>
    """;
}
