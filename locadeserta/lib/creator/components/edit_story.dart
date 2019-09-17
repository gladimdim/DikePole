import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/text_editor.dart';
import 'package:locadeserta/creator/components/create_view.dart';
import 'package:locadeserta/creator/components/edit_node_view.dart';
import 'package:locadeserta/creator/components/fat_button.dart';
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
          if (story.root == story.currentPage)
            StoryViewHeader(
              story: story,
              onEdit: () {
                Navigator.pop(context);
              },
            ),
          if (story.root != story.currentPage)
            RaisedButton(
              child: Text("Go to root"),
              onPressed: () {
                setState(() {
                  story.currentPage = story.root;
                });
              },
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Options: "),
              IconButton(
                onPressed: () {
                  setState(() {
                    story.currentPage.addNextPageWithText("Test");
                  });
                },
                icon: Icon(Icons.add_box),
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: story.currentPage.next.map((PageNext next) {
                  return BorderedContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: TextEditor(
                            maxLines: 1,
                            text: next.text,
                            onSave: (String newText) {
                              setState(() {
                                next.text = newText;
                              });
                            },
                          )
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.details,
                          ),
                          onPressed: () {
                            // TODO: implement next page render
                            setState(() {
                              story.goToNextPage(next);
                            });
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              story.currentPage.removeNextPage(next);
                            });
                          },
                          icon: Icon(Icons.remove_circle),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Add new text passage: "),
              RaisedButton(
                child: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    story.currentPage.addNodeWithText("");
                  });
                },
              ),
            ],
          ),
          Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Column(
                  children: story.currentPage.nodes.map((node) {
                    var imageType = node.imageType;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BorderedContainer(
                        child: ListTile(
                          title: Text(firstNCharsFromString(node.text, 60)),
                          leading: imageType == null
                              ? Icon(Icons.texture)
                              : Image(
                                  image: BackgroundImage.getAssetImageForType(
                                      imageType)),
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              ExtractEditPassageView.routeName,
                              arguments: EditPassageViewArguments(
                                node: node,
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                story.currentPage.removeNode(node);
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
          SlideableButton(
            child: FatButton(text: LDLocalizations.of(context).startStory),
            onPress: () async {
              story.reset();
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
