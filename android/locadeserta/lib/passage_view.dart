import 'package:flutter/material.dart';
import 'package:locadeserta/animations/TweenImage.dart';
import 'package:locadeserta/models/story_bridge.dart';
import 'package:locadeserta/animations/SlideableButton.dart';
import 'package:locadeserta/models/BackgroundImage.dart';


class Passage extends StatefulWidget {
  final Story currentStory;
  final Function(String pid, int i) onNextOptionSelected;

  Passage({this.currentStory, this.onNextOptionSelected});

  @override
  State<StatefulWidget> createState() => PassageState();
}

class PassageState extends State<Passage> with TickerProviderStateMixin {
  ScrollController _passageScrollController = new ScrollController();

  Widget createButton(String text, int i) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
          height: 100.0,
          child: SlideableButton(
            buttonText: text,
            onPress: () {
              _nextWithChoice(i);
            },
          ),
      ),
    );
  }

  void _nextWithChoice(int i) {
    _passageScrollController.animateTo(0,
        duration: Duration(milliseconds: 50),
        curve: Curves.fastOutSlowIn);
    BackgroundImage.nextRandomForType(ImageType.BOAT);
    widget.onNextOptionSelected(null, i);
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
    return SlideableButton(
        buttonText: "Далі",
        onPress: () {
          _next();
        });
  }

  void _next() {
    if (widget.currentStory.canContinue == true) {
      _passageScrollController.animateTo(0,
          duration: Duration(milliseconds: 50), curve: Curves.fastOutSlowIn);
      widget.onNextOptionSelected("Next", -1);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List();

    list.addAll(
      [_buildTextRow(context)],
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

  Widget _buildTextRow(BuildContext context) {
    print(widget.currentStory.currentTags);
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _passageScrollController,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width * 0.79,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                border: Border.all(color: Colors.black, width: 3.0),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    widget.currentStory.currentText,
                    style: TextStyle(
                      fontFamily: "Raleway-Bold",
                      fontSize: 18,
                    ) //Theme.of(context).textTheme.title,
                  ),
                ),
              ),
            ),
            TweenImage(
              duration: 1,
              first:  BackgroundImage.getAssetImageForType(ImageType.BOAT),
              last:  BackgroundImage.getColoredAssetImageForType(ImageType.BOAT),
              height: 800.0
            )
          ],
        ),
      ),
    );
  }
}

