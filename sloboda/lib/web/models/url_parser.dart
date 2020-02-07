import 'dart:js' as js;
import 'package:fluri/fluri.dart';

class UrlParser {
  static bool isSupported = true;

  static Map getUrlParams() {
    var uri = Uri.tryParse(js.context['location']['href']);

    return uri.queryParameters;
  }

  static updateLanguage(String newLocale) {
//    var uri = Uri.tryParse(js.context['location']['href']);
//    var fluri = Fluri.fromUri(uri);
//    var queryParams = fluri.queryParameters;
//    Map<String, dynamic> map = Map.from(queryParams);
//    map['lang'] = newLocale;
//    fluri.setQueryParam('lang', newLocale);
//    print("uri: ${fluri.toString()}");
//    js.context['history'].callMethod('pushState', [{}, null, fluri.toString()]);
  }

  static String getLanguage() {
    var params = UrlParser.getUrlParams();
    return params['lang'];
  }
}
