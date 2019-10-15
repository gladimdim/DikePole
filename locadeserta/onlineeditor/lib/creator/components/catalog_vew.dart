import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:onlineeditor/components/narrow_scaffold.dart';
import 'package:onlineeditor/models/story_catalogs.dart';

class CatalogGladStoryView extends StatefulWidget {
  static const routeName = "/catalog_view";

  @override
  _CatalogGladStoryViewState createState() => _CatalogGladStoryViewState();
}

class _CatalogGladStoryViewState extends State<CatalogGladStoryView> {
  Future fetchCatalog() async {
    return await http.get("https://locadeserta.com/stories/index.json");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchCatalog(),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Container();
              break;
            case ConnectionState.done:
              List<CatalogGladStory> list =
                  CatalogGladStory.fromJsonList(snapshot.data.body);
              return ListView(
                scrollDirection: Axis.vertical,
                children: list
                    .map(
                      (element) => ListTile(
                        title: Text(element.title),
                        subtitle: Text(element.description),
                        leading: Text("${element.settingYear}"),
                        onTap: () => Navigator.pushNamed(
                          context,
                          "/editStories",
                          arguments: element.url,
                        ),
                      ),
                    )
                    .toList(),
              );
          }
          return Container();
        });
  }
}
