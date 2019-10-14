import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineeditor/creator/components/catalog_vew.dart';

import 'creator/components/edit_node_view.dart';
import 'creator/components/edit_story.dart';
import 'creator/components/game_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print(settings.name);
    switch (settings.name) {
      case "/editPassage":
        return MaterialPageRoute(
          builder: (_) => EditNodeView(
            node: args,
          ),
        );
        break;
      case "/editStories":
        return MaterialPageRoute(
          builder: (_) => EditStoryView(storyUrl: args),
        );
      case "/":
        return MaterialPageRoute(builder: (_) => CatalogGladStoryView());
      case "/play":
        return MaterialPageRoute(
            builder: (_) => GameView(
                  story: args,
                ));
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
