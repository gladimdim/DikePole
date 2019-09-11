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
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';

class EditStoryView extends StatefulWidget {
  final StoryBuilder storyBuilder;
  final Locale locale;
  final Auth auth;

  EditStoryView(
      {@required this.storyBuilder, @required this.locale, @required this.auth});

  @override
  _EditStoryViewState createState() => _EditStoryViewState();
}

class _EditStoryViewState extends State<EditStoryView> {
  Map<int, bool> expandedIndexes = Map();

  @override
  Widget build(BuildContext context) {
    var storyBuilder = widget.storyBuilder;
    return Scaffold(
      appBar: AppBar(
        title: Text(LDLocalizations.of(context).createStory),
        actions: <Widget>[
          FlatButton(
            child: Text(
              LDLocalizations.of(context).save,
              style: Theme.of(context).textTheme.title,
            ),
            onPressed: () async {
              var user = await widget.auth.currentUser();
              await StoryPersistence.instance.writeStory(user, widget.storyBuilder);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          StoryViewHeader(
            storyBuilder: storyBuilder,
            onEdit: () {
              Navigator.pop(context);
            },
          ),
          CreatePassage(
            onAdd: (PassageTypes type) {
              setState(() {
                storyBuilder.addPassage(passageBuilderFromType(type));
              });
            },
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: storyBuilder.getPassages().map((passage) {
                return ListTile(
                  title: Text(firstNCharsFromString(passage.text, 60)),
                  leading: Image(
                    image:
                        BackgroundImage.getAssetImageForType(passage.imageType),
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      ExtractEditPassageView.routeName,
                      arguments: EditPassageViewArguments(
                          story: storyBuilder, passageBuilder: passage),
                    );
                  },
                  trailing: InkWell(
                    child: Icon(Icons.delete),
                    onTap: () {
                      setState(() {
                        storyBuilder.removePassage(passage);
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          )),
          SlideableButton(
            child: optionBox(context, LDLocalizations.of(context).startStory),
            onPress: () async {
              await Navigator.pushNamed(
                context,
                ExtractArgumentsGameView.routeName,
                arguments: GameViewArguments(
                  locale: widget.locale,
                  story: storyBuilder.toModel(),
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
  final StoryBuilder storyBuilder;
  final Locale locale;

  EditStoryViewArguments({this.storyBuilder, this.locale});
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
      storyBuilder: args.storyBuilder,
      locale: args.locale,
    );
  }
}
