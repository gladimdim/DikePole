import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components.dart';
import 'package:locadeserta/creator/components/create_passage.dart';
import 'package:locadeserta/creator/components/create_view.dart';
import 'package:locadeserta/creator/components/edit_passage_view.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/creator/story/persistence.dart';
import 'package:locadeserta/creator/story/story_builder.dart';
import 'package:locadeserta/creator/utils/utils.dart';
import 'package:locadeserta/models/Auth.dart';

class EditStoryView extends StatefulWidget {
  final StoryBuilder story;
  final Locale locale;
  final Auth auth;

  EditStoryView(
      {@required this.story, @required this.locale, @required this.auth});

  @override
  _EditStoryViewState createState() => _EditStoryViewState();
}

class _EditStoryViewState extends State<EditStoryView> {
  Map<int, bool> expandedIndexes = Map();

  @override
  Widget build(BuildContext context) {
    var story = widget.story;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create story"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Save",
              style: Theme.of(context).textTheme.title,
            ),
            onPressed: () async {
              var user = await widget.auth.currentUser();
              var db = await StoryPersistence.instance
                  .writeStory(user, widget.story);
              print("done $db");
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          StoryViewHeader(
            story: story,
            onEdit: () {
              Navigator.pop(context);
            },
          ),
          CreatePassage(
            onAdd: (PassageTypes type) {
              setState(() {
                story.addPassage(passageBuilderFromType(type));
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:
                  story.getPassages().map((passage) {
                    return ListTile(
                      title: Text(firstNCharsFromString(passage.text, 60)),
                      leading: Image(
                        image: AssetImage(passage.imagePath),
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          ExtractEditPassageView.routeName,
                          arguments: EditPassageViewArguments(
                              story: story, passageBuilder: passage),
                        );
                      },
                    );
                  }).toList(),
              ),
            )
          ),
          SlideableButton(
            child: optionBox(context, "Play"),
            onPress: () async {
              await Navigator.pushNamed(
                context,
                ExtractArgumentsGameView.routeName,
                arguments: GameViewArguments(
                  locale: widget.locale,
                  story: story.toModel(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class EditStoryViewArguments {
  final StoryBuilder story;
  final Locale locale;

  EditStoryViewArguments({this.story, this.locale});
}

class ExtractEditStoryViewArguments extends StatelessWidget {
  static const routeName = "/edit_story";
  final Auth auth;

  ExtractEditStoryViewArguments({@required this.auth});

  Widget build(BuildContext context) {
    final EditStoryViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return EditStoryView(
      auth: auth,
      story: args.story,
      locale: args.locale,
    );
  }
}
