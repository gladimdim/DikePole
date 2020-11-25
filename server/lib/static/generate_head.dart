import 'package:server/static/meta_tags_generator.dart';

String generateHead() {
  return """
   <head>
          <meta charset="utf-8"/>
          <title>Інтерактивна історія. Дике Поле.</title>
         ${generateMetaTags()}
         </head>
  """;
}
