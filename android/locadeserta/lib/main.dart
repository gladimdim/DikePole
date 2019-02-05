import 'package:flutter/material.dart';
import "package:flutter/services.dart" show rootBundle;
import "package:locadeserta/story.dart";
import "dart:convert";

Future<String> loadStoryAsset() async {
  return await rootBundle.loadString("stories/twinery.json");
}

Future loadStory() async {
  String result = await loadStoryAsset();
  Map map = jsonDecode(result);
  List<StoryNode> nodes = new List();
  for (var node in map["passages"]) {
    nodes.add(node);
  }

  return new Story(current: "1", passages: nodes);
}

void main() => runApp(LocaDesertaApp());

class LocaDesertaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _current = 1;
  Story story;

  void _incrementCounter() {
    setState(() {
      _current++;
    });
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
            Text(
              'You have pushed the button this many times:',
            ),
            FutureBuilder(
                future: loadStory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      story.getCurrentStory().text.toString(),
                      style: Theme.of(context).textTheme.display1,
                    );
                  } else if (snapshot.hasError){
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
