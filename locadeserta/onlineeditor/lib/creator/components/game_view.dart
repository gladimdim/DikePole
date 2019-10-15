import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/components/game_app_bar.dart';
import 'package:onlineeditor/components/game_component.dart';
import 'package:onlineeditor/creator/components/story_view.dart';
import 'package:onlineeditor/creator/story/story.dart';

class GameView extends StatefulWidget {
  final Story story;

  GameView({this.story});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<GameView> {

  @override
  Widget build(BuildContext context) {
    return GameViewScaffold(
      appBar: GameAppBar(
        title: LDLocalizations.previewStory,
        onResetStory: () {
          setState(() {
            widget.story.reset();
          });
        },
        onExportStory: () {},
      ),
      child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: StoryView(currentStory: widget.story,),
      ),
    );
  }
}

class GameViewArguments {
  final Story story;

  GameViewArguments({this.story});
}

class ExtractArgumentsGameView extends StatelessWidget {
  static const routeName = "/play";

  Widget build(BuildContext context) {
    final GameViewArguments args = ModalRoute.of(context).settings.arguments;

    return GameView(
      story: args.story,
    );
  }
}
