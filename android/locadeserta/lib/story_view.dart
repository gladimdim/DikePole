import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/passage_view.dart';
import 'package:locadeserta/persistence.dart';
import 'package:locadeserta/models/story_bridge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/Auth.dart';

class StoryView extends StatefulWidget {
  final CatalogStory catalogStory;
  Persistence persistence;
  final User user;
  final bool loadState;

  StoryView({@required this.user, @required this.catalogStory, this.loadState});

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
      widget.persistence =
          Persistence(bridge: storyBridge, storage: Firestore.instance);
      String stateJson;
      try {
        stateJson = await widget.persistence.getStateJsonForUserAndCatalog(
            widget.user, widget.catalogStory);
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
              appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () async {
                      await widget.persistence.saveStateToStorageForUser(
                          widget.user, widget.catalogStory);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.clear_all),
                    onPressed: () async {
                      await storyBridge.resetStory();
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
}
