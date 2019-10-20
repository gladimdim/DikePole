import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/creator/story/persistence.dart';
import 'package:onlineeditor/creator/story/story.dart';
import 'package:onlineeditor/models/LDUser.dart';
import 'package:onlineeditor/views/inherited_auth.dart';

class CatalogGladStoryView extends StatefulWidget {
  static const routeName = "/catalog_view";

  @override
  _CatalogGladStoryViewState createState() => _CatalogGladStoryViewState();
}

class _CatalogGladStoryViewState extends State<CatalogGladStoryView> {
  AsyncMemoizer _storyBuilderCatalogMemo = AsyncMemoizer();

  Future fetchCatalog() async {
    return await http.get("https://locadeserta.com/stories/index.json");
  }

  Future _fetchData(LDUser user) {
    return _storyBuilderCatalogMemo.runOnce(() async {
      return StoryPersistence.instance.getUserStories(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = InheritedAuth.of(context).auth.getUser();
    return FutureBuilder(
        future: _fetchData(user),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: Text(LDLocalizations.loadingStory));
              break;
            case ConnectionState.done:
              List<Story> list = snapshot.data;
              return ListView(
                scrollDirection: Axis.vertical,
                children: list
                    .map(
                      (element) => ListTile(
                        title: Text(element.title),
                        subtitle: Text(element.description),
                        onTap: () => Navigator.pushNamed(
                          context,
                          "/editStories",
                          arguments: element,
                        ),
                      ),
                    )
                    .toList(),
              );
          }
          return Center(child: Text(LDLocalizations.loadingStory));
        });
  }
}
