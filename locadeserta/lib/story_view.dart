import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/passage_view.dart';
import 'package:locadeserta/models/persistence.dart';
import 'package:locadeserta/models/story_bridge.dart';
import 'package:toast/toast.dart';
import 'models/Auth.dart';

class StoryView extends StatefulWidget {
  final CatalogStory catalogStory;
  final User user;

  StoryView({@required this.user, @required this.catalogStory});

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  StoryBridge storyBridge;

  @override
  void initState() {
    _initStoryBridge();
    super.initState();
  }

  Future<StoryBridge> _initStoryBridge() async {
    if (storyBridge == null) {
      storyBridge = StoryBridge();
      String stateJson;
      try {
        stateJson = await Persistence.instance
            .getStateJsonForUserAndCatalog(widget.user, widget.catalogStory);
      } catch (e) {
        print(e.toString());
      }

      await storyBridge.initStory(
          storyJson: widget.catalogStory.inkJson, state: stateJson);
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
              backgroundColor: Theme
                  .of(context)
                  .backgroundColor,
              appBar: AppBar(
                actions: <Widget>[
                  FlatButton(
                    textColor: Theme
                        .of(context)
                        .textTheme
                        .title
                        .color,
                    child: Text(
                      LDLocalizations
                          .of(context)
                          .save,
                    ),
                    onPressed: () => _onSavePressed(context, Persistence.instance),
                  ),
                  FlatButton(
                    textColor: Theme
                        .of(context)
                        .textTheme
                        .title
                        .color,
                    child: Text(LDLocalizations
                        .of(context)
                        .reset),
                    onPressed: () async {
                      await storyBridge.resetStory(
                        storyJson: widget.catalogStory.inkJson,);
                    },
                  )
                ],
                title: Text(widget.catalogStory.title),
              ),
              body: snapshot.hasData
                  ? Passage(
                  currentStory: currentStory,
                  onNextOptionSelected: (s, i) async {
                    if (s == "Next") {
                      await storyBridge.doContinue();
                    } else {
                      await storyBridge.chooseChoiceIndex(i);
                    }
                  })
                  : Center(child: CircularProgressIndicator()));
        });
  }


  _onSavePressed(BuildContext context, Persistence instance) async {
    try {
      await instance.saveStateToStorageForUser(
          widget.user, widget.catalogStory, storyBridge);
      Toast.show(LDLocalizations.of(context).storySaved, context);
    } catch (e) {
      Toast.show(LDLocalizations.of(context).storyNotSaved, context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }
}