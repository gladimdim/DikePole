import 'package:flutter/material.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/StatisticsView.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/web/creator/components/catalog_view.dart';

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
