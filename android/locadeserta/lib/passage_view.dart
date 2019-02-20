import 'dart:math';

import 'package:flutter/material.dart';
import 'package:locadeserta/story_bridge.dart';

class Passage extends StatefulWidget {
  final Story currentStory;
  final random = new Random().nextInt(3);
  final Function(String pid, int i) onNextOptionSelected;

  Passage({this.currentStory, this.onNextOptionSelected});

  @override
  State<StatefulWidget> createState() => PassageState();
}

class PassageState extends State<Passage> {
  Widget createButton(String text, int i) {
    return RaisedButton(
      onPressed: () {
        widget.onNextOptionSelected(text, i);
      },
      child: Text(text),
    );
  }

  List<Widget> createOptionList(List<String> options) {
    List<Widget> optionButtons = new List();
    int index = 0;
    optionButtons.addAll(options.map((value) {
      return createButton(value, index++);
    }));

    return optionButtons;
  }

  Widget createContinue() {
    return FlatButton(
        child: Text("Далі"),
        onPressed: () {
          widget.onNextOptionSelected("Next", -1);
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List();
    list.add(Center(
      child: Image.asset(
          "images/background/boat_" + widget.random.toString() + ".jpg",
          height: 100.0),
    ));

    list.add(Expanded(
      child: SingleChildScrollView(
        child: Text(
          widget.currentStory.currentText,
          style: Theme.of(context).textTheme.title,
        ),
      ),
    ));

    widget.currentStory.canContinue == true
        ? list.add(createContinue())
        : list.addAll(createOptionList(widget.currentStory.currentChoices));


    return Column(children: list);
  }
}
