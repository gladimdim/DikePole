import 'package:flutter/material.dart';
import "package:flutter/services.dart" show rootBundle;
import 'package:locadeserta/passage_view.dart';
import "package:locadeserta/story.dart";
import "package:locadeserta/fancyfab.dart";
import "dart:convert";

Future<Story> loadStory() async {
  final json = await rootBundle.loadString("stories/LocaDeserta.json");
  Map map = jsonDecode(json);

  return Story.fromJson(map);
}

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
      home: MyHomePage(title: 'Дике Поле. Початок легенд.'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Story story;

  void nextStorySelected(dynamic pid) {
    story.setCurrentStoryByPid(pid);
    setState(() {});
  }

  ScrollController _passageScrollController;

  _scrollingPassage() {
    if (_passageScrollController.offset >=
        _passageScrollController.position.maxScrollExtent) {
      debugPrint("Reached the end");
    } else {}
  }

  @override
  void initState() {
    _passageScrollController = ScrollController();
    _passageScrollController.addListener(_scrollingPassage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadStory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (story == null) {
              story = snapshot.data;
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Center(
                child: Passage(
                  story: story.getCurrentStory(),
                  scrollController: _passageScrollController,
                ),
              ),
              floatingActionButton: FancyFab(
                  onPressed: (String name) {
                    setState(() {
                      if (name == "Start Again") {
                        story.setCurrentStoryByPid("1");
                      } else {
                        story.setCurrentStoryByPid(
                            story.getNextPidForName(name));
                      }
                    });
                  },
                  answers: (story == null)
                      ? []
                      : story.getCurrentStory().links.map((nextStory) {
                          return nextStory.name;
                        }).toList()),
            );
          } else if (snapshot.hasError) {
            return Text("Failed to load assets: ${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }
}
