import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineeditor/StatisticsView.dart';
import 'package:onlineeditor/creator/components/catalog_view.dart';
import 'package:onlineeditor/models/LDAuth.dart';
import 'package:onlineeditor/root.dart';
import 'package:onlineeditor/views/inherited_auth.dart';
import 'package:onlineeditor/views/login_view.dart';

import 'creator/components/edit_node_view.dart';
import 'creator/components/edit_story.dart';
import 'creator/components/game_view.dart';

var ldAuth = LDAuth();

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print(settings.name);
    switch (settings.name) {
      case LoginView.routeName:
        return MaterialPageRoute(builder: (_) => LoginView());
      case StatisticsView.routeName:
        return MaterialPageRoute(builder: (_) => StatisticsView());
      case CatalogGladStoryView.routeName:
        return MaterialPageRoute(
          builder: (_) =>
              InheritedAuth(child: CatalogGladStoryView(), auth: ldAuth),
        );
      case "/editPassage":
        return MaterialPageRoute(
          builder: (_) => EditNodeView(
            node: args,
          ),
        );
        break;
      case "/editStories":
        return MaterialPageRoute(
          builder: (_) =>
              InheritedAuth(child: EditStoryView(story: args), auth: ldAuth),
        );
      case "/":
        return MaterialPageRoute(
            builder: (_) => InheritedAuth(child: LoginView(), auth: ldAuth));
      case "/play":
        return MaterialPageRoute(
            builder: (_) => GameView(
                  story: args,
                ));
      case Root.routeName:
        return MaterialPageRoute(
            builder: (_) => InheritedAuth(child: Root(), auth: ldAuth));
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
