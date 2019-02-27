import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/passage_view.dart';
import 'package:locadeserta/persistence.dart';
import 'package:locadeserta/story_bridge.dart';

class StoryView extends StatefulWidget {
  final StoryBridge storyBridge;
  StoryView({this.storyBridge});

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  Story currentStory;
  static const platform = const MethodChannel('gladimdim.locadeserta/Ink');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.storyBridge.tick(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            currentStory = widget.storyBridge.story;
            return Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () async {
                      Persistence pers = Persistence(bridge: widget.storyBridge);
                      await pers.saveStoryToFile("game2");
                      await widget.storyBridge.getInventory();
                      print("123");
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.clear_all),
                    onPressed: () async {
                      await widget.storyBridge.resetStory();
                      setState(() {});
                    },
                  )
                ],
                title: Text("Цицора"),
              ),
              body: Passage(
                  currentStory: currentStory,
                  onNextOptionSelected: (s, i) async {
                    if (s == "Next") {
                      await widget.storyBridge.doContinue();
                    } else {
                      await widget.storyBridge.chooseChoiceIndex(i);
                    }
                    setState(() {});
                  }),
            );
          } else if (snapshot.hasError) {
            return Text("Failed to load assets: ${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }
}
