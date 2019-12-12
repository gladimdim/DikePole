import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/models/Localizations.dart';

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
                return loadingScreen(context);
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
                          title: Text(LDLocalizations.registeredUsers,
                              style: Theme.of(context).textTheme.title),
                          subtitle: Text("$userCount",
                              style: Theme.of(context).textTheme.body1),
                        )
                      ]..addAll(storyStats.keys
                          .map(
                            (key) => ListTile(
                              title: Text(
                                LDLocalizations.labelStoryTitle + ": $key",
                                style: Theme.of(context).textTheme.title,
                              ),
                              subtitle: Text(
                                LDLocalizations.timesRead +
                                    ": ${storyStats[key]}",
                                style: Theme.of(context).textTheme.body1,
                              ),
                            ),
                          )
                          .toList()));
                } else {
                  return Container(
                      child: Text(LDLocalizations.failedToLoadStats));
                }
            }
            return loadingScreen(context);
          },
        ),
      ),
    );
  }

  Widget loadingScreen(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(LDLocalizations.loadingStats),
          SizedBox(
            height: 50,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
