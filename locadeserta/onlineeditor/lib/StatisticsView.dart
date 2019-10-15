import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:onlineeditor/components/narrow_scaffold.dart';

class StatisticsView extends StatefulWidget {
  static const String routeName = "/statistics";

  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  Future fetchStats() {
    return http.get(
        "https://us-central1-dike-pole-1548444278704.cloudfunctions.net/playStatistic1s");
  }

  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: "Stats of story readings",
      actions: [],
      body: FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: FutureBuilder(
          future: fetchStats(),
          builder: (context, snapshot) {
            print("connection state ${snapshot.connectionState}");
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return FractionallySizedBox(widthFactor: 0.1, heightFactor: 0.1, child: CircularProgressIndicator());
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  print("-----------------------");
                  Map response = jsonDecode(snapshot.data.body);
                  print(response);
                  return ListView(
                    scrollDirection: Axis.vertical,
                    children: response
                        .keys.map(
                          (key) =>
                          ListTile(
                            title: Text(key),
                            subtitle: Text("${response[key]}"),
                          ),
                    )
                        .toList(),
                  );
                } else {
                  return Container(
                    child: Text("Failed to load the statistics, try again later")
                  );
                }
            }
            return SizedBox(width: 50, height: 50, child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
