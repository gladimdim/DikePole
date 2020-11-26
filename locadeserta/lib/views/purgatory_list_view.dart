import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/server/server.dart';
import 'package:locadeserta/waiting_screen.dart';

class PurgatoryListView extends StatefulWidget {
  static const String routeName = "/purgatory";

  @override
  _PurgatoryListViewState createState() => _PurgatoryListViewState();
}

class _PurgatoryListViewState extends State<PurgatoryListView> {
  final AsyncMemoizer _catalogListMemo = AsyncMemoizer();
  List stories = [];

  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: LDLocalizations.labelUserStoriesCatalog,
      actions: [],
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return WaitingScreen();
              break;
            case ConnectionState.done:
              if (snapshot.data == null || snapshot.data.length == 0) {
                return Text("Нічого не знайшли");
              } else {
                stories = List.from(snapshot.data);
                return _buildCatalogView(context, stories);
              }
              break;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCatalogView(context, List stories) {
    return Column(
      children: stories
          .map((story) => BorderedContainer(child: FatContainer(text: story)))
          .toList(),
    );
  }

  _fetchData() {
    return _catalogListMemo.runOnce(() async {
      return await getPurgatoryStories();
    });
  }
}
