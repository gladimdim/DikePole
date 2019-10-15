import 'package:flutter/material.dart';
import 'package:onlineeditor/StatisticsView.dart';
import 'package:onlineeditor/components/app_bar_custom.dart';
import 'package:onlineeditor/components/narrow_scaffold.dart';
import 'package:onlineeditor/creator/components/catalog_vew.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: "Welcome to GladStory stories!",
      body: CatalogGladStoryView(),
      actions: [
        AppBarObject(
          text: "Stats",
          onTap: () => {
            Navigator.pushNamed(context, StatisticsView.routeName),
          }
        )
      ],
    );
  }
}
