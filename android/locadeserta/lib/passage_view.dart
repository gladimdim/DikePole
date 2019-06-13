import 'package:flutter/material.dart';
import 'package:locadeserta/animations/TweenImage.dart';
import 'package:locadeserta/animations/slide_widget.dart';
import 'package:locadeserta/components.dart';
import 'package:locadeserta/models/story_bridge.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/models/BackgroundImage.dart';
import 'models/Localizations.dart';

class Passage extends StatefulWidget {
  final Story currentStory;
  final Function(String pid, int i) onNextOptionSelected;

  Passage({this.currentStory, this.onNextOptionSelected});

  @override
  State<StatefulWidget> createState() => PassageState();
}

class PassageState extends State<Passage> with TickerProviderStateMixin {
  ScrollController _passageScrollController = new ScrollController();
  ImageType _lastImageType = ImageType.BULRUSH;

  @override
  Widget build(BuildContext context) {
    if (widget.currentStory.theEnd || widget.currentStory.toBeContinued) {
      var text = widget.currentStory.theEnd
          ? LDLocalizations.of(context).theEnd
          : LDLocalizations.of(context).toBeContinued;
      return Column(
        children: <Widget>[
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TweenImage(
              first: BackgroundImage.getAssetImageForType(ImageType.LANDING),
              duration: 3,
              repeat: true,
              last: BackgroundImage.getColoredAssetImageForType(ImageType.LANDING),
            ),
          )
        ],
      );
    } else {
      return Column(
        children: [
          _buildTextRow(context),
          ..._createButtons(context),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      );
    }
  }

  List<Widget> _createButtons(BuildContext context) {
    return widget.currentStory.canContinue == true
        ? [createContinue(context)]
        : createOptionList(widget.currentStory.currentChoices);
  }

  Widget createButton(String text, int i) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100.0,
        child: SlideableButton(
          onPress: () {
            _nextWithChoice(i);
          },
          child: optionBox(
            context,
            text,
          ),
        ),
      ),
    );
  }

  void _nextWithChoice(int i) {
    _passageScrollController.animateTo(0,
        duration: Duration(milliseconds: 50), curve: Curves.fastOutSlowIn);
    BackgroundImage.nextRandomForType(_lastImageType);
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

  Widget createContinue(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SlideableButton(
          child: optionBox(
            context,
            LDLocalizations.of(context).Continue,
          ),
          onPress: () {
            _next();
          }),
    );
  }

  void _next() {
    if (widget.currentStory.canContinue == true) {
      _passageScrollController.animateTo(0,
          duration: Duration(milliseconds: 50), curve: Curves.fastOutSlowIn);
      widget.onNextOptionSelected("Next", -1);
    }
  }

  Widget _buildTextRow(BuildContext context) {
    print("current tags: ${widget.currentStory.currentTags}");
    var currentTags = widget.currentStory.currentTags;
    var randomImageType = _lastImageType;
    if (currentTags != null && currentTags.isNotEmpty) {
      randomImageType = BackgroundImage.imageTypeFromCurrentTags(currentTags);
      _lastImageType = randomImageType;
    }
    print("Random image type: $randomImageType");
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _passageScrollController,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            SlideWidget(
              slide: true,
              direction: SlideDirection.Right,
              child: Container(
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
                      ),
                    ),
                  ),
                ),
              ),
            ),
            TweenImage(
                duration: 3,
                first: BackgroundImage.getAssetImageForType(randomImageType),
                last: BackgroundImage.getColoredAssetImageForType(
                    randomImageType),
                height: 700.0)
          ],
        ),
      ),
    );
  }
}
