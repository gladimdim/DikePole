import 'package:flutter/material.dart';
import 'package:locadeserta/story.dart';

class Passage extends StatelessWidget {
  final StoryNode story;

  Passage({this.story});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset("images/background/boat_2.jpg"),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Text(
              story.text.toString(),
              style: Theme.of(context).textTheme.title,
            ),
          ),
        )
      ],
    );
  }
}
