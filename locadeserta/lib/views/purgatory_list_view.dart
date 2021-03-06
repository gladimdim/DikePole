import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slide_right_navigation.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/components/transforming_page_view.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/loaders/catalogs.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/server/server.dart';
import 'package:locadeserta/story_details_view.dart';
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
            case ConnectionState.done:
              var data = snapshot.data as List;
              if (data.length == 0) {
                return Text("Нічого не знайшли");
              } else {
                stories = List.from(data);
                return _buildCatalogView(context, stories);
              }
          }
        },
      ),
    );
  }

  Widget _buildCatalogView(context, List stories) {
    return TransformingPageView(
      titles: stories.map((story) => story).toList(),
      scrollDirection: Axis.vertical,
      onStorySelected: (index) async {
        var storyBody = await getPurgatoryStoryByName(stories[index]);
        var story = Story.fromJson(storyBody);
        Navigator.push(
          context,
          SlideRightNavigation(
            widget: GameView(
              story: story,
              catalogStory: null,
            ),
          ),
        );
      },
      onDetailsSelected: (index) async {
        var storyBody = await getPurgatoryStoryByName(stories[index]);
        var story = Story.fromJson(storyBody);
        var catalogStory = CatalogStory(
          title: story.title,
          description: story.description,
          year: story.year.toString(),
          author: story.authors,
        );
        await Navigator.pushNamed(
          context,
          ExtractStoryDetailsViewArguments.routeName,
          arguments: StoryDetailsViewArguments(
            expanded: true,
            catalogStory: catalogStory,
            onReadPressed: () async {
              var storyBody = await getPurgatoryStoryByName(stories[index]);
              var story = Story.fromJson(storyBody);
              Navigator.push(
                context,
                SlideRightNavigation(
                  widget: GameView(
                    story: story,
                    catalogStory: null,
                  ),
                ),
              );
            },
            onDetailPressed: () {},
          ),
        );
      },
    );
  }

  Future _fetchData() {
    return _catalogListMemo.runOnce(() async {
      return await getPurgatoryStories();
    });
  }
}
