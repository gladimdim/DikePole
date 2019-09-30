import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/text_editor.dart';
import 'package:locadeserta/creator/components/edit_node_view.dart';
import 'package:locadeserta/creator/components/fat_button.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/creator/story/persistence.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/creator/utils/utils.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';
import 'package:share_extend/share_extend.dart';

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
  Map<PageNext, TextEditingController> _textControllers = {};

  @override
  Widget build(BuildContext context) {
    var story = widget.story;
    return NarrowScaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  if (story.root != story.currentPage)
                    Align(
                      alignment: Alignment.centerRight,
                      child: BorderedContainer(
                        child: FlatButton.icon(
                          icon: Icon(Icons.arrow_back),
                          label: Text(LDLocalizations.of(context).labelBack),
                          onPressed: () {
                            setState(() {
                              var parent =
                                  story.findParentOfPage(story.currentPage);
                              if (parent != null) {
                                story.currentPage = parent;
                              } else {
                                story.currentPage = story.root;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  Checkbox(
                    value: story.currentPage.isTheEnd(),
                    onChanged: (newValue) {
                      setState(() {
                        story.currentPage.endType =
                            newValue ? EndType.ALIVE : null;
                      });
                    },
                  ),
                  Center(
                      child: Text(LDLocalizations.of(context).labelIsTheEnd)),
                  if (story.currentPage.isTheEnd()) ...[
                    Radio(
                      value: EndType.DEAD,
                      groupValue: story.currentPage.endType,
                      onChanged: (newValue) {
                        setState(() {
                          story.currentPage.endType = EndType.DEAD;
                        });
                      },
                    ),
                    Center(
                        child: Text(
                            LDLocalizations.of(context).labelIsTheEndDead)),
                    Radio(
                      value: EndType.ALIVE,
                      groupValue: story.currentPage.endType,
                      onChanged: (newValue) {
                        setState(() {
                          story.currentPage.endType = EndType.ALIVE;
                        });
                      },
                    ),
                    Center(
                        child: Text(
                            LDLocalizations.of(context).labelIsTheEndAlive))
                  ]
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton.icon(
                onPressed: () {
                  setState(() {
                    story.currentPage.addNextPageWithText(
                        LDLocalizations.of(context).optionPlaceHolder);
                  });
                },
                icon: Icon(Icons.add_box),
                label: Text(LDLocalizations.of(context).labelOptions),
              ),
            ),
            if (story.currentPage.next.length == 0)
              Text(LDLocalizations.of(context).optionsListEmpty),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: story.currentPage.next.map((PageNext next) {
                    if (!_textControllers.containsKey(next)) {
                      _textControllers[next] = TextEditingController();
                    }
                    _textControllers[next].text = next.text;
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: BorderedContainer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                                height: 50,
                                width: 200,
                                child: TextEditor(
                                  controller: _textControllers[next],
                                  maxLines: 1,
                                  text: next.text,
                                  onSubmitted: (String newText) {
                                    next.text = newText;
                                  },
                                  onSave: (newValue) {
                                    next.text = newValue;
                                  },
                                )),
                            IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_right,
                              ),
                              onPressed: () {
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
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton.icon(
                onPressed: () {
                  setState(() {
                    story.currentPage.addNodeWithText("");
                  });
                },
                icon: Icon(Icons.add_box),
                label: Text(LDLocalizations.of(context).addNewPassage),
              ),
            ),
            if (story.currentPage.next.length == 0)
              Text(LDLocalizations.of(context).passageListEmpty),
            Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  child: Column(
                    children: story.currentPage.nodes.reversed.map((node) {
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

                              var user = await widget.auth.currentUser();
                              await StoryPersistence.instance
                                  .writeStory(user, widget.story);
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
              child: FatButton(
                text: LDLocalizations.of(context).startStory,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPress: () async {
                story.reset();
                await Navigator.pushNamed(
                  context,
                  ExtractArgumentsGameView.routeName,
                  arguments:
                      GameViewArguments(locale: widget.locale, story: story),
                );
                story.reset();
              },
            )
          ],
        ),
        title: LDLocalizations.of(context).createStory,
        actions: [
          AppBarObject(
            text: LDLocalizations.of(context).save,
            onTap: _saveStoryCallback,
          ),
          AppBarObject(
              text: LDLocalizations.of(context).backToStories,
              onTap: () {
                Navigator.pop(context);
              }),
          AppBarObject(
            text: LDLocalizations.of(context).exportGladStoryToJson,
            onTap: () {
              var json = widget.story.toJson();
              ShareExtend.share(json, "text");
            }
          ),
        ]);
  }

  _saveStory() async {
    var user = await widget.auth.currentUser();
    await StoryPersistence.instance.writeStory(user, widget.story);
    setState(() {});
  }

  _saveStoryCallback() {
    _saveStory();
  }

  @override
  void dispose() {
    super.dispose();
    _textControllers.forEach((key, controller) {
      controller.dispose();
    });
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
