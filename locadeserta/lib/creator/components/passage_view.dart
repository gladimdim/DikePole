import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/BorderedRandomImageForType.dart';
import 'package:locadeserta/creator/story/Story.dart';
import 'package:locadeserta/components.dart';
import 'package:locadeserta/creator/utils/utils.dart';
import 'package:locadeserta/models/background_image.dart';

class PassageView extends StatefulWidget {
  final Story currentStory;

  PassageView({
    this.currentStory,
  });

  @override
  State<StatefulWidget> createState() => PassageState();
}

class PassageState extends State<PassageView> with TickerProviderStateMixin {
  ScrollController _passageScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextSection(context),
        ..._createButtons(context),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  List<Widget> _createButtons(BuildContext context) {
    switch (widget.currentStory.currentPassage.type) {
      case PassageTypes.Continue:
        return [createContinue(context)];
      case PassageTypes.Option:
        {
          PassageOption option =
              widget.currentStory.currentPassage as PassageOption;
          return createOptionList(option.options);
        }
    }
    return [];
  }

  Widget createButton(String text, int i) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.075,
        child: SlideableButton(
          onPress: () {
            _next(i);
          },
          child: optionBox(
            context,
            text,
          ),
        ),
      ),
    );
  }

  void _next(int i) {
    setState(() {
      widget.currentStory.next(i);
    });
  }

  List<Widget> createOptionList(List<NextOption> options) {
    List<Widget> optionButtons = List();
    int index = 0;
    optionButtons.addAll(options.map((value) {
      return createButton(value.text, index++);
    }));

    return optionButtons;
  }

  Widget createContinue(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SlideableButton(
          child: optionBox(
            context,
            "Next",
          ),
          onPress: () {
            _next(null);
          }),
    );
  }

  List<HistoryItem> _getLastFiveItems(List list) {
    var amountOfPassages = list.length;
    if (amountOfPassages > 5) {
      return list.sublist(amountOfPassages - 5, amountOfPassages);
    } else {
      return list;
    }
  }

  Widget _buildTextSection(BuildContext context) {
    Future.delayed(Duration(milliseconds: 300), _scroll(context));

    return Expanded(
        child: SingleChildScrollView(
      controller: _passageScrollController,
      child: Column(
        children: _getLastFiveItems(widget.currentStory.history)
            .map(
              (HistoryItem historyItem) => PassageItemView(
                historyItem,
              ),
            )
            .toList(),
      ),
    ));
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

class PassageItemView extends StatelessWidget {
  final HistoryItem historyItem;

  PassageItemView(this.historyItem);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (historyItem.imagePath != null)
          BorderedRandomImageByPath(
            getImagesForType(historyItem.imagePath),
          ),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: getDecorationForContainer(context),
          child: Text(
            historyItem.text == "" ? "The End" : historyItem.text,
            style: TextStyle(
              fontFamily: "Raleway-Bold",
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
