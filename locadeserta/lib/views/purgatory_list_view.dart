import 'package:flutter/material.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/models/Localizations.dart';

class PurgatoryListView extends StatefulWidget {
  static const String routeName = "/purgatory";
  @override
  _PurgatoryListViewState createState() => _PurgatoryListViewState();
}

class _PurgatoryListViewState extends State<PurgatoryListView> {
  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: LDLocalizations.labelUserStoriesCatalog,
      actions: [],
    );
  }
}
