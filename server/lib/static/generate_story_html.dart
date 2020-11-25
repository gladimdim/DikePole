import 'package:server/static/generate_head.dart';

String generateStoryHtml(String markdown) {
  return """
        <!doctype html>
        <html>
       ${generateHead()}
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
}
