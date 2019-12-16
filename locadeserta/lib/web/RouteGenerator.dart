import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locadeserta/StatisticsView.dart';
import 'package:locadeserta/creator/components/edit_node_view.dart';
import 'package:locadeserta/web/catalog_view.dart';
import 'package:locadeserta/web/creator/components/catalog_view.dart';
import 'package:locadeserta/web/creator/components/edit_node_sequence_view.dart';
import 'package:locadeserta/web/main_editor_view.dart';
import 'package:locadeserta/web/main_menu.dart';
import 'package:locadeserta/web/models/LDAuth.dart';
import 'package:locadeserta/web/views/import_gladstories_view.dart';
import 'package:locadeserta/web/views/inherited_auth.dart';
import 'package:locadeserta/web/views/login_view.dart';

import 'creator/components/edit_story.dart';
import 'creator/components/game_view.dart';

var ldAuth = LDAuth();

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print(settings.name);
    switch (settings.name) {
      case ImportGladStoryView.routeName:
        return MaterialPageRoute(
            builder: (_) => InheritedAuth(
                  child: ImportGladStoryView(),
                  auth: ldAuth,
                ));
      case CatalogView.routeName:
        Map ar = args;
        return MaterialPageRoute(
            builder: (_) => InheritedAuth(
                  auth: ldAuth,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(ar["catalogStory"].title),
                    ),
                    body: CatalogView(
                        catalogStory: ar["catalogStory"],
                        expanded: ar["expanded"],
                        onReadPressed: ar["onReadPressed"],
                        onDetailPressed: ar["onDetailPressed"]),
                  ),
                ));
      case MainMenu.routeName:
        return MaterialPageRoute(
            builder: (_) => InheritedAuth(child: MainMenu(), auth: ldAuth));
      case LoginView.routeName:
        return MaterialPageRoute(builder: (_) => LoginView());
      case StatisticsView.routeName:
        return MaterialPageRoute(builder: (_) => StatisticsView());
      case EditNodeSequence.routeName:
        Map ar = args;
        return MaterialPageRoute(
            builder: (_) => EditNodeSequence(
                  page: ar["page"],
                  startIndex: ar["startIndex"],
                ));
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
      case EditStoryView.routeName:
        return MaterialPageRoute(
          builder: (_) =>
              InheritedAuth(child: EditStoryView(story: args), auth: ldAuth),
        );
      case "/":
        return MaterialPageRoute(
            builder: (_) => InheritedAuth(child: LoginView(), auth: ldAuth));
      case "/play":
        return MaterialPageRoute(
            builder: (_) => InheritedAuth(
                  auth: ldAuth,
                  child: GameView(
                    story: args,
                  ),
                ));
      case MainEditorView.routeName:
        return MaterialPageRoute(
            builder: (_) =>
                InheritedAuth(child: MainEditorView(), auth: ldAuth));
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
