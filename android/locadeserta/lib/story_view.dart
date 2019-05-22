import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/passage_view.dart';
import 'package:locadeserta/persistence.dart';
import 'package:locadeserta/models/story_bridge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryView extends StatefulWidget {
  final CatalogStory catalogStory;

  final String uid;

  StoryView({this.uid, this.catalogStory});

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
      String state;
      try {
        DocumentReference userState =
            Firestore.instance.collection("user_states").document(widget.uid);
        var snapshot = await userState.get();
        if (snapshot.data != null) {
          state = snapshot.data['statejson'];
        }
      } catch (e) {
        print(e.toString());
      }

      await storyBridge.initStory(
          storyJson: widget.catalogStory.inkJson, state: state);
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
                      Persistence pers = Persistence(bridge: storyBridge);
                      String stateJson = await pers.getStateJson();
                      DocumentReference userState = Firestore.instance
                          .collection("user_states")
                          .document(widget.uid);
                      DocumentSnapshot doc = await userState.get();
                      if (doc.data == null) {
                        await userState.setData({
                          "catalogidreference": widget.catalogStory.id,
                          "statejson": stateJson,
                        });
                      } else {
                        userState.updateData({
                          "statejson": stateJson,
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.clear_all),
                    onPressed: () async {
                      await storyBridge.resetStory();
                    },
                  )
                ],
                // TODO: Read book title from firebase
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
