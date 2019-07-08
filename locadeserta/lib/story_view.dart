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
  bool expanded = false;

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
                                if (s == "Next") {
                                  await storyBridge.doContinue();
                                } else {
                                  await storyBridge.chooseChoiceIndex(i);
                                }
                              })
                          : Center(child: CircularProgressIndicator()),
                    ),
                    Positioned(
                      top: 0,
                      left: 0.0,
                      right: 0,
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        height: expanded ? 64 : 32,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Center(
                                child: Text(
                                  widget.catalogStory.title,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .title
                                        .fontSize,
                                    color:
                                        Theme.of(context).textTheme.title.color,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            FlatButton(
                              color: Theme.of(context).primaryColor,
                              child: Row(
                                children: <Widget>[
                                  Text("Menu"),
                                  Icon(
                                    expanded ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                                  )
                                ],
                              ),
                              textColor: Colors.white,
                              onPressed: _toggleExpandedMenu,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
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

  _toggleExpandedMenu() {
    setState(() {
      expanded = !expanded;
    });
  }
}
