import 'package:flutter/material.dart';
import "package:flutter/services.dart" show rootBundle;
import "package:locadeserta/story.dart";
import "package:locadeserta/fancyfab.dart";
import "dart:convert";

Future<Story> loadStory() async {
  final json = await rootBundle.loadString("stories/twinery.json");
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

  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
                future: loadStory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    story = snapshot.data;
                    return Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Text(
                          story.getCurrentStory().text.toString(),
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  setState(() {});
                  return CircularProgressIndicator();
                }),
          ],
        ),
      ),
      floatingActionButton: FancyFab(
          onPressed: _incrementCounter,
          answers: (story == null)
              ? []
              : story.getCurrentStory().links.map((nextStory) {
                  return nextStory.name;
                }).toList()), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
