import 'dart:math';

import 'package:flutter/material.dart';
import 'package:locadeserta/story.dart';

class Passage extends StatelessWidget {
  final StoryNode story;
  final random  = new Random();
  Passage({this.story});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset("images/background/boat_" + random.nextInt(2).toString() + ".jpg"),
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
