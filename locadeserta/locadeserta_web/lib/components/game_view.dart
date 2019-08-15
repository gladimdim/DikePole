import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';
import 'package:locadeserta_web/components/passage_view.dart';
import 'package:locadeserta_web/story/Story.dart';

class GameView extends StatefulWidget {
  final Story story;
  final Locale locale;

  GameView({this.locale, this.story});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) {
    print(widget.story.passages);
    return Scaffold(
      body: PassageView(currentStory: widget.story),
    );
  }
}

class GameViewArguments {
  final Story story;
  final Locale locale;

  GameViewArguments({this.locale, this.story});
}

class ExtractArgumentsGameView extends StatelessWidget {
  static const routeName = "/play";

  Widget build(BuildContext context) {
    final GameViewArguments args = ModalRoute.of(context).settings.arguments;

    return GameView(
      locale: args.locale,
      story: args.story,
    );
  }
}
