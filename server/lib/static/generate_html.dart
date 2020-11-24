import 'package:server/static/meta_tags_generator.dart';

String generateHtml(String markdown) {
  return """
        <!doctype html>
        <html>
        <head>
          <meta charset="utf-8"/>
          <title>Інтерактивна історія. Дике Поле.</title>
         ${generateMetaTags()}
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
}
