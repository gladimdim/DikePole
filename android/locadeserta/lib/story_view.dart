import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/passage_view.dart';
import 'package:locadeserta/story_bridge.dart';

class StoryView extends StatefulWidget {
  Story currentStory;
  final StoryBridge storyBridge = new StoryBridge();

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  StoryBridge storyBridge;
  bool showFAB = false;
  static const platform = const MethodChannel('gladimdim.locadeserta/Ink');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.storyBridge.tick(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            widget.currentStory = widget.storyBridge.story;
            return Scaffold(
              appBar: AppBar(
                title: Text("Цицора"),
              ),
              body: Passage(
                  currentStory: widget.currentStory,
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
