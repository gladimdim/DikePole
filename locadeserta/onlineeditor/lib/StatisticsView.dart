import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/components/narrow_scaffold.dart';

class StatisticsView extends StatefulWidget {
  static const String routeName = "/statistics";

  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  Future fetchStats() {
    return http.get(
        "https://us-central1-dike-pole-1548444278704.cloudfunctions.net/playStatistics");
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
                return Center(child: Text(LDLocalizations.backToStories));
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  Map response = jsonDecode(snapshot.data.body);
                  return ListView(
                    scrollDirection: Axis.vertical,
                    children: response.keys
                        .map(
                          (key) => ListTile(
                            title: Text("Story title: $key"),
                            subtitle: Text("Times read: ${response[key]}"),
                          ),
                        )
                        .toList(),
                  );
                } else {
                  return Container(
                      child: Text(
                          "Failed to load the statistics, try again later"));
                }
            }
            return Center(child: Text(LDLocalizations.backToStories));
          },
        ),
      ),
    );
  }
}
