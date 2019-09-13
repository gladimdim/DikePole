import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/BorderedRandomImageForType.dart';
import 'package:locadeserta/creator/components/fat_button.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/creator/utils/utils.dart';
import 'package:locadeserta/models/Localizations.dart';

class StoryView extends StatefulWidget {
  final Story currentStory;

  StoryView({
    this.currentStory,
  });

  @override
  State<StatefulWidget> createState() => PassageState();
}

class PassageState extends State<StoryView> with TickerProviderStateMixin {
  ScrollController _passageScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextSection(context),
        createContinue(context),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  Widget createButton(String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.075,
        child: SlideableButton(
          onPress: () {

          },
          child: FatButton(
            text: text,
          ),
        ),
      ),
    );
  }

  void _next() {
    setState(() {
      widget.currentStory.next();
    });
  }

  List<Widget> createOptionList(List<Page> nextPages) {
    return nextPages.map((page) {
      return createButton("test----");
    }).toList();
  }

  Widget createContinue(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SlideableButton(
          child: FatButton(
            text: LDLocalizations.of(context).next,
          ),
          onPress: () {
            _next();
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
                  (HistoryItem historyItem) =>
                  PassageItemView(
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
        if (historyItem.imageType != null)
          BorderedRandomImageByType(historyItem.imageType),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(8.0),
          width: MediaQuery
              .of(context)
              .size
              .width * 0.95,
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
