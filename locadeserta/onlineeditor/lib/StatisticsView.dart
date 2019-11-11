import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/components/app_bar_custom.dart';
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
      title: LDLocalizations.statisticsTitle,
      actions: [
        AppBarObject(
            text: LDLocalizations.labelBack,
            onTap: () {
              Navigator.pop(context);
            })
      ],
      body: FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: FutureBuilder(
          future: fetchStats(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return loadingScreen();
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  Map response = jsonDecode(snapshot.data.body);
                  Map storyStats = response["storyStats"];
                  var userCount = response["users"];
                  return ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        ListTile(
                          title: Text(LDLocalizations.registeredUsers),
                          subtitle: Text("$userCount"),
                        )
                      ]..addAll(storyStats.keys
                          .map(
                            (key) => ListTile(
                              title: Text("$key"),
                              subtitle: Text(LDLocalizations.timesRead +
                                  ": ${storyStats[key]}"),
                            ),
                          )
                          .toList()));
                } else {
                  return Container(
                      child: Text(LDLocalizations.failedToLoadStats));
                }
            }
            return loadingScreen();
          },
        ),
      ),
    );
  }

  Widget loadingScreen() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Column(
          children: [
            Text(LDLocalizations.loadingStats),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
