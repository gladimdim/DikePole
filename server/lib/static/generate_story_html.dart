import 'package:markdown/markdown.dart';
import 'package:server/static/generate_head.dart';

String generateStoryHtml(String markdown) {
  return """
        <!doctype html>
        <html>
       ${generateHead()}
        <body>
          <div>Дике Поле: Козацька Доля. Більше історій тут: <a href="https://locadeserta.com/">Всесвіт Дикого Поля</a></div>
          <div id="content">
          ${markdownToHtml(markdown)}</div>
        </body>
        </html>
    """;
}
