import 'package:flutter/material.dart';
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/StatisticsView.dart';
import 'package:onlineeditor/components/app_bar_custom.dart';
import 'package:onlineeditor/components/narrow_scaffold.dart';
import 'package:onlineeditor/creator/components/catalog_view.dart';

class MainEditorView extends StatefulWidget {
  static const routeName = "/root";

  @override
  _MainEditorViewState createState() => _MainEditorViewState();
}

class _MainEditorViewState extends State<MainEditorView> {
  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: LDLocalizations.appTitle,
      body: CatalogGladStoryView(),
      actions: [
        AppBarObject(
          text: LDLocalizations.statisticsTitle,
          onTap: () => {
            Navigator.pushNamed(context, StatisticsView.routeName),
          },
        )
      ],
    );
  }
}
