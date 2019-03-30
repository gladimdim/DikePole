import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/passage_view.dart';
import 'package:locadeserta/persistence.dart';
import 'package:locadeserta/story_bridge.dart';

class StoryView extends StatefulWidget {

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

  Future _initStoryBridge() async {
    storyBridge = StoryBridge();
    Persistence pers = Persistence(bridge: storyBridge);
    String state;
    try {
      state = await pers.getStoryFromFile("game2");
    } catch (e) {}
    await storyBridge.initStory(state: state);
  }

  Story currentStory;
  static const platform = const MethodChannel('gladimdim.locadeserta/Ink');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:storyBridge.streamStory.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            currentStory = storyBridge.story;
            return Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () async {
                      Persistence pers = Persistence(bridge: storyBridge);
                      await pers.saveStoryToFile("game2");
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.clear_all),
                    onPressed: () async {
                      await storyBridge.resetStory();
                    },
                  )
                ],
                title: Text("Цецора"),
              ),
              body: Passage(
                  currentStory: currentStory,
                  onNextOptionSelected: (s, i) async {
                    if (s == "Next") {
                      await storyBridge.doContinue();
                    } else {
                      await storyBridge.chooseChoiceIndex(i);
                    }
                  }),
            );
          } else if (snapshot.hasError) {
            return Text("Failed to load assets: ${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }
}
