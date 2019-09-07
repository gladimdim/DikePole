import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components.dart';
import 'package:locadeserta/creator/components/create_passage.dart';
import 'package:locadeserta/creator/components/create_view.dart';
import 'package:locadeserta/creator/components/edit_passage_view.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/creator/story/Story.dart';
import 'package:locadeserta/creator/story/story_builder.dart';
import 'package:locadeserta/creator/utils/utils.dart';

class EditStoryView extends StatefulWidget {
  final StoryBuilder story;
  final Locale locale;

  EditStoryView({this.story, this.locale});

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
      ),
      body: ListView(
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
          ...story.getPassages().map((passage) {
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
          }),
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

  Widget build(BuildContext context) {
    final EditStoryViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return EditStoryView(
      story: args.story,
      locale: args.locale,
    );
  }
}