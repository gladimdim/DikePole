import 'package:flutter/material.dart';
import 'package:locadeserta/components/BorderedRandomImageForType.dart';
import 'package:locadeserta/creator/components/fat_button.dart';
import 'package:locadeserta/models/story_history.dart';
import 'package:locadeserta/models/story_bridge.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/models/background_image.dart';
import 'models/Localizations.dart';

class Passage extends StatefulWidget {
  final Story currentStory;
  final Function(dynamic passage, int i) onNextOptionSelected;

  Passage({
    this.currentStory,
    this.onNextOptionSelected,
  });

  @override
  State<StatefulWidget> createState() => PassageState();
}

class PassageState extends State<Passage> with TickerProviderStateMixin {
  ScrollController _passageScrollController = new ScrollController();
  ImageType _imageType = ImageType.BULRUSH;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextRow(context),
        ..._createButtons(context),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  List<Widget> _buildTheEnd(BuildContext context) {
    var text = widget.currentStory.theEnd
        ? LDLocalizations.theEnd
        : LDLocalizations.toBeContinued;
    return <Widget>[
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
        child: BorderedRandomImageByType(ImageType.LANDING),
      )
    ];
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
          child: FatButton(
            text: text,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  void _nextWithChoice(int i) {
    _imageType = _createImageType(widget.currentStory);
    BackgroundImage.nextRandomForType(
      _imageType,
    );
    var randomImage = BackgroundImage.getRandomImageForType(_imageType);
    var passageItem = HistoryItemImage(
      [randomImage.getImagePath(), randomImage.getImagePathColored()],
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
          child: FatButton(
            text: LDLocalizations.Continue,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onPress: () {
            _next();
          }),
    );
  }

  void _next() {
    if (widget.currentStory.canContinue == true) {
      widget.onNextOptionSelected(
          HistoryItemText(widget.currentStory.currentText), -1);
    }
  }

  Widget _buildTextRow(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200), _scroll(context));
    return Expanded(
      child: SingleChildScrollView(
        controller: _passageScrollController,
        child: Column(
          children: [
            ...widget.currentStory.storyHistory.getHistory().map((var passageItem) {
              if (passageItem == null) {
                return Container();
              }
              Widget container;
              switch (passageItem.type) {
                case PassageTypes.IMAGE:
                  container = BorderedRandomImageByPath(passageItem.value);
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
                      passageItem.value == "" ? LDLocalizations.storyBegin : passageItem.value,
                      style: TextStyle(
                        fontFamily: "Raleway-Bold",
                        fontSize: 18,
                      ),
                    ),
                  );
              }
              return container;
            }),
            if (widget.currentStory.theEnd || widget.currentStory.toBeContinued)
              ..._buildTheEnd(context),
          ],
        ),
      ),
    );
  }

  ImageType _createImageType(Story story) {
    print("current tags: ${story.currentTags}");
    var currentTags = story.currentTags;
    if (currentTags != null && currentTags.isNotEmpty) {
      return BackgroundImage.imageTypeFromCurrentTags(currentTags);
    } else {
      return ImageType.FOREST;
    }
  }

  _scroll(BuildContext context) {
    return () {
      if (_passageScrollController.hasClients) {
        var position = _passageScrollController.position;
        _passageScrollController.animateTo(
          position.maxScrollExtent,
          duration: Duration(milliseconds: 50),
          curve: Curves.easeOutBack,
        );
      }
    };
  }
}
