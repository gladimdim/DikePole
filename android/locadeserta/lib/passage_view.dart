import 'dart:math';

import 'package:flutter/material.dart';
import 'package:locadeserta/story.dart';

class Passage extends StatefulWidget {
  final Story currentStory;
  final random = new Random().nextInt(3);
  final Function(String pid) onNextOptionSelected;

  Passage({this.currentStory, this.onNextOptionSelected});

  @override
  State<StatefulWidget> createState() => PassageState();
}

class PassageState extends State<Passage> {
  final _passageController = PageController();

  void _onOptionSelected() {
    _passageController.animateToPage(0,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  Widget createButton(String text) {
    return ListTile(
      onTap: () {
        _onOptionSelected();
        widget.onNextOptionSelected(text);
      },
      title: Text(text),
    );
  }

  ListView createOptionList(List<String> options) {
    List<Widget> optionButtons = new List();
    optionButtons.addAll(options.map((value) {
      return createButton(value);
    }));

    if (optionButtons.length == 0) {
      optionButtons.add(createButton("Start Again"));
    }
    return ListView(
      children: optionButtons,
    );
  }

  Widget createContinue() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Далі"),
          onTap: () {
            widget.onNextOptionSelected("Next");
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: _passageController,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
                "images/background/boat_" + widget.random.toString() + ".jpg",
                height: 200.0),
            Expanded(
              flex: 1,
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Text(
                    widget.currentStory.currentText,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              ),
            )
          ],
        ),
        widget.currentStory.canContinue == true
            ? createContinue()
            : createOptionList(widget.currentStory.currentChoices)
      ],
    );
  }
}
