import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:locadeserta/passage_view.dart';
import "package:locadeserta/story.dart";

void main() => runApp(LocaDesertaApp());

class LocaDesertaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loca Deserta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeWidget(title: 'Дике Поле. Початок легенд.'),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);
  final String title;
  Story currentStory;
  final StoryBridge storyBridge = new StoryBridge();

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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
                title: Text(widget.title),
              ),
              body: Center(
                child: Passage(
                    currentStory: widget.currentStory,
                    onNextOptionSelected: (s) async {
                      if (s == "Next") {
                        var next = await widget.storyBridge.doContinue();
                        setState(() {});
                      } else {
                        print("kuku00");
                      }
                    }),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Failed to load assets: ${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }
}
