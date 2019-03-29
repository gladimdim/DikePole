import 'package:flutter/material.dart';
import 'package:locadeserta/LandingView.dart';
import 'package:locadeserta/persistence.dart';
import 'package:locadeserta/story_view.dart';
import 'package:locadeserta/story_bridge.dart';

void main() => runApp(LocaDesertaApp());

class LocaDesertaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loca Deserta',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: HomeWidget(title: 'Дике Поле. Початок легенд .'),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: LandingView(
          onStartGamePressed: () async {
            StoryBridge bridge = StoryBridge();
            Persistence pers = Persistence(bridge: bridge);
            String state;
            try {
              state = await pers.getStoryFromFile("game2");
            } catch (e) {}
            await bridge.initStory(state: state);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StoryView(storyBridge: bridge)));
          },
        ));
  }
}
