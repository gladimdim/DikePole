import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/components/AppBarCustom.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/story_history.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/passage_view.dart';
import 'package:locadeserta/models/persistence.dart';
import 'package:locadeserta/models/story_bridge.dart';
import 'package:toast/toast.dart';

class StoryView extends StatefulWidget {
  final CatalogStory catalogStory;
  final User user;

  StoryView({@required this.user, @required this.catalogStory});

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  StoryBridge storyBridge;
  List _previousPassages = List();

  @override
  void initState() {
    _initStoryBridge();
    super.initState();
  }

  Future<StoryBridge> _initStoryBridge() async {
    if (storyBridge == null) {
      storyBridge = StoryBridge();
      String stateJson;
      String historyJson;
      try {
        stateJson = await Persistence.instance
            .getStateJsonForUserAndCatalog(widget.user, widget.catalogStory);
        historyJson = await Persistence.instance
            .getHistoryJsonForUserAndCatalog(widget.user, widget.catalogStory);
      } catch (e) {
        print(e.toString());
      }

      await storyBridge.initStory(
          storyJson: widget.catalogStory.inkJson,
          state: stateJson,
          historyJson: historyJson);
    }
    return storyBridge;
  }

  Story currentStory;
  static const platform = const MethodChannel('gladimdim.locadeserta/Ink');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: storyBridge.streamStory.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Failed to load assets: ${snapshot.error}");
        }

        currentStory = storyBridge.story;
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: snapshot.hasData
                      ? Passage(
                          currentStory: currentStory,
                          onNextOptionSelected: (s, i) async {
                            _previousPassages.add(s);
                            switch (s.type) {
                              case PassageTypes.TEXT:
                                await storyBridge.doContinue();
                                break;
                              case PassageTypes.IMAGE:
                                await storyBridge.chooseChoiceIndex(i, s);
                            }
                          })
                      : Center(child: CircularProgressIndicator()),
                ),
                AppBarCustom(
                  title: widget.catalogStory.title,
                  appBarButtons: [
                    AppBarObject(
                        onTap: () =>
                            _onSavePressed(context, Persistence.instance),
                        text: LDLocalizations.of(context).save),
                    AppBarObject(
                      onTap: () => Navigator.pop(context),
                      text: LDLocalizations.of(context).backToStories,
                    ),
                    AppBarObject(
                      onTap: _resetStory,
                      text: LDLocalizations.of(context).reset,
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _onSavePressed(BuildContext context, Persistence instance) async {
    try {
      await instance.saveStateToStorageForUser(
          widget.user, widget.catalogStory, storyBridge);
      Toast.show(LDLocalizations.of(context).storySaved, context);
    } catch (e) {
      Toast.show(LDLocalizations.of(context).storyNotSaved, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }

  _resetStory() async {
    await storyBridge.resetState();
  }
}
