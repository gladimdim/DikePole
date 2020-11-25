import 'package:server/static/generateCSSStyles.dart';
import 'package:server/static/meta_tags_generator.dart';

String generateHead() {
  return """
   <head>
          <meta charset="utf-8"/>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>Інтерактивна історія. Дике Поле.</title>
         ${generateMetaTags()}
         ${generateCssStyles()}
         </head>
  """;
}
