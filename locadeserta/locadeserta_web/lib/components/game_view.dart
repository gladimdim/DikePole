import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';
import 'package:locadeserta_web/components/passage_view.dart';
import 'package:locadeserta_web/story/Story.dart';

class GameView extends StatefulWidget {
  final Story story = Story.generate();
  final Locale locale;

  GameView({this.locale});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PassageView(currentStory: widget.story),
    );
  }
}
