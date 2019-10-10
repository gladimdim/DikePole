import 'package:flutter/material.dart';

import 'creator/components/edit_node_view.dart';
import 'creator/components/edit_story.dart';
import 'creator/components/game_view.dart';
import 'creator/story/story.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData(
      primaryColor: Colors.black,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      fontFamily: 'Roboto',
      textTheme: TextTheme(title: TextStyle(color: Colors.white)));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      initialRoute: "/edit_story",
      routes: {
        "/edit_story": (context) => EditStoryView(
              story: Story(
                  authors: "Me",
                  title: "Yo",
                  description: "DD",
                  root: Page(nodes: [PageNode(text: "Test")])),
            ),
        ExtractEditPassageView.routeName: (context) => ExtractEditPassageView(),
        ExtractArgumentsGameView.routeName: (context) =>
            ExtractArgumentsGameView(),
      },
    );
  }
}
