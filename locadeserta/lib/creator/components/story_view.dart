import 'package:flutter/material.dart';
import 'package:locadeserta/InheritedAuth.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/BorderedRandomImageForType.dart';
import 'package:locadeserta/creator/components/fat_button.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/creator/utils/utils.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';
import 'package:locadeserta/models/persistence.dart';

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
  initState() {
    Future.delayed(Duration.zero, () {
      widget.currentStory.historyChanges.listen((data) {
        _saveStateToStorage(widget.currentStory, context);
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<HistoryItem>>(
      stream: widget.currentStory.historyChanges,
      initialData: [],
      builder: (context, snapshot) {
        var history = snapshot.data;
        return Column(
          children: [
            _buildTextSection(history, context),
            if (widget.currentStory.canContinue()) createContinue(context),
            if (!widget.currentStory.canContinue())
              ...createOptionList(widget.currentStory.currentPage.next),
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        );
      },
    );

  }

  void _next(context) {
//    _saveStateToStorage(widget.currentStory, context);
    setState(() {
      var currentImageType =
          widget.currentStory.currentPage.getCurrentNode().imageType;
      if (currentImageType != null) {
        BackgroundImage.nextRandomForType(currentImageType);
      }
      widget.currentStory.doContinue();
    });
  }

  Future _saveStateToStorage(Story story, BuildContext context) async {
    var auth = InheritedAuth.of(context).auth;
    var user = await auth.currentUser();
    await Persistence.instance.saveGladStoryToStorageForUser(user, story);
  }

  List<Widget> createOptionList(List<PageNext> nextPages) {
    return nextPages.map((page) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.075,
          child: SlideableButton(
            onPress: () {
              setState(() {
                widget.currentStory.goToNextPage(page);
              });
            },
            child: FatButton(
              text: page.text,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget createContinue(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SlideableButton(
          child: FatButton(
            text: LDLocalizations.of(context).next,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onPress: () {
            _next(context);
          }),
    );
  }

  Widget _buildTextSection(List<HistoryItem> history, BuildContext context) {
    Future.delayed(Duration(milliseconds: 300), _scroll(context));

    return Expanded(
        child: SingleChildScrollView(
      controller: _passageScrollController,
      child: Column(
        children: [
          ...history
              .map(
                (HistoryItem historyItem) => PassageItemView(
                  historyItem,
                ),
              )
              .toList(),
          if (!widget.currentStory.canContinue() && widget.currentStory.currentPage.isTheEnd())
            Text(LDLocalizations.of(context).theEnd),
        ],
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
          BorderedRandomImageByPath(historyItem.imagePath),
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
