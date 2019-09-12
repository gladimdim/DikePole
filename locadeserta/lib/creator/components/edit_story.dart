import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components.dart';
import 'package:locadeserta/creator/components/create_view.dart';
import 'package:locadeserta/creator/components/edit_passage_view.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/creator/story/persistence.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/creator/utils/utils.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';

class EditStoryView extends StatefulWidget {
  final Story story;
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
        title: Text(LDLocalizations.of(context).createStory),
        actions: <Widget>[
          FlatButton(
            child: Text(
              LDLocalizations.of(context).save,
              style: Theme.of(context).textTheme.title,
            ),
            onPressed: () async {
              var user = await widget.auth.currentUser();
              await StoryPersistence.instance.writeStory(user, widget.story);
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
          RaisedButton(
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                story.root.addNodeWithText("");
              });
            },
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: story.root.nodes.map((node) {
                var image = node == null ? Container() : Image(
                    image: BackgroundImage.getAssetImageForType(node.imageType));
                return ListTile(
                  title: Text(firstNCharsFromString(node.text, 60)),
                  leading: image,
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      ExtractEditPassageView.routeName,
                      arguments: EditPassageViewArguments(
                        node: node,
                      ),
                    );
                  },
                  trailing: InkWell(
                    child: Icon(Icons.delete),
                    onTap: () {
                      setState(() {
                        story.root.removeNode(node);
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
                arguments:
                    GameViewArguments(locale: widget.locale, story: story),
              );
            },
          )
        ],
      ),
    );
  }
}

class EditStoryViewArguments {
  final Story story;
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
