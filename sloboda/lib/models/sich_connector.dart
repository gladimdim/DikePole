import 'dart:convert';

import 'package:http/http.dart' as http;

class SichConnector {
  final String statsUrl = '/sichStats';
  final String root = 'http://192.168.1.199:1701';
  final String send = '/sendSupport';
  final String gold = '/gold';
  final String cossacks = '/cossacks';

  Future<Map> readStats() async {
    var response = await http.get(root + statsUrl);
    return jsonDecode(response.body);
  }

  Future<Map> sendCossacks(int amount) async {
    var response = await http
        .put(root + send + cossacks + '/${amount.toString()}', body: {});
    return jsonDecode(response.body);
  }
}
