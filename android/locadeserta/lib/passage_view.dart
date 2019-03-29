import 'dart:math';
import 'package:flutter/material.dart';
import 'package:locadeserta/story_bridge.dart';

class Passage extends StatefulWidget {
  final Story currentStory;
  final random = new Random().nextInt(7);
  final Function(String pid, int i) onNextOptionSelected;

  Passage({this.currentStory, this.onNextOptionSelected});

  @override
  State<StatefulWidget> createState() => PassageState();
}

class PassageState extends State<Passage> {
  Widget createButton(String text, int i) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
          height: 100.0,
          child: RaisedButton(
            color: Colors.blue[50 * (i + 1)],
            onPressed: () {
              widget.onNextOptionSelected(text, i);
            },
            child: Text(text),
          )),
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
    return SizedBox(
      height: 100.0,
      child: FlatButton(
          color: Colors.lightGreen,
          child: Text(
            "Далі",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: () {
            widget.onNextOptionSelected("Next", -1);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List();

    list.addAll(
      [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Card(
                child: Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.4,
                      child: Container(
                        height: 400,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: AssetImage(
                                  "images/background/boat_" +
                                      widget.random.toString() +
                                      ".jpg",
                                ))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        widget.currentStory.currentText,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );

    final buttons = widget.currentStory.canContinue == true
        ? [createContinue()]
        : createOptionList(widget.currentStory.currentChoices);
    list.addAll(buttons);
    return Column(
      children: list,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
