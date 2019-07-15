import 'package:flutter/material.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/components.dart';
import 'package:locadeserta/models/passage_item.dart';
import 'package:locadeserta/models/story_bridge.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/models/background_image.dart';
import 'models/Localizations.dart';

class Passage extends StatefulWidget {
  final Story currentStory;
  final Function(PassageItem, int i) onNextOptionSelected;
  final List<PassageItem> previousPassages;

  Passage(
      {this.currentStory, this.onNextOptionSelected, this.previousPassages});

  @override
  State<StatefulWidget> createState() => PassageState();
}

class PassageState extends State<Passage> with TickerProviderStateMixin {
  ScrollController _passageScrollController = new ScrollController();
  ImageType _imageType = ImageType.BULRUSH;

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
              last: BackgroundImage.getColoredAssetImageForType(
                  ImageType.LANDING),
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
        height: MediaQuery.of(context).size.height * 0.075,
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
    var passageItem = PassageItem(
      type: PassageTypes.IMAGE,
      value: _imageType,
    );
    BackgroundImage.nextRandomForType(
      _imageType,
    );
    widget.onNextOptionSelected(passageItem, i);
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
      widget.onNextOptionSelected(
          PassageItem(
              type: PassageTypes.TEXT, value: widget.currentStory.currentText),
          -1);
    }
  }

  Widget _buildTextRow(BuildContext context) {
    print("current tags: ${widget.currentStory.currentTags}");
    var currentTags = widget.currentStory.currentTags;
    if (currentTags != null && currentTags.isNotEmpty) {
      _imageType = BackgroundImage.imageTypeFromCurrentTags(currentTags);
    }
    print("Random image type: $_imageType");

    Future.delayed(Duration(milliseconds: 100), _scrollDown);

    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            controller: _passageScrollController,
            children: [
              ...widget.previousPassages.map((PassageItem passageItem) {
                Widget container;
                switch (passageItem.type) {
                  case PassageTypes.IMAGE:
                    container = Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 3.0,
                        ),
                      ),
                      child: TweenImage(
                        repeat: true,
                        duration: 3,
                        first: BackgroundImage.getAssetImageForType(
                            passageItem.value),
                        last: BackgroundImage.getColoredAssetImageForType(
                            passageItem.value),
                        imageFit: BoxFit.fitWidth,
                      ),
                    );
                    break;
                  case PassageTypes.TEXT:
                    container = Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 3.0,
                        ),
                      ),
                      child: Text(
                        passageItem.value,
                        style: TextStyle(
                          fontFamily: "Raleway-Bold",
                          fontSize: 18,
                        ),
                      ),
                    );
                }
                return container;
              }),
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3.0,
                  ),
                ),
                child: Text(
                  widget.currentStory.currentText,
                  style: TextStyle(
                    fontFamily: "Raleway-Bold",
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _scrollDown() {
    if (_passageScrollController.hasClients) {
      var position = _passageScrollController.position;
      _passageScrollController.animateTo(
        position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOutBack,
      );
    }
  }
}
