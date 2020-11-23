import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/edit_node_sequence_view.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/creator/components/publish_screen.dart';
import 'package:locadeserta/creator/components/text_editor.dart';
import 'package:locadeserta/creator/utils/utils.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';
import 'package:locadeserta/models/story_persistence.dart';
import 'package:locadeserta/views/story_graph_view.dart';
import 'package:share_extend/share_extend.dart';

class EditStoryView extends StatefulWidget {
  final Story story;
  static const routeName = "/editStories";

  EditStoryView({@required this.story});

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
                          label: Text(
                            LDLocalizations.labelBack,
                            style: Theme.of(context).textTheme.headline6,
                          ),
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
                    activeColor: Theme.of(context).primaryColor,
                    checkColor: Theme.of(context).backgroundColor,
                    value: story.currentPage.isTheEnd(),
                    onChanged: (newValue) {
                      setState(() {
                        story.currentPage.endType =
                            newValue ? EndType.ALIVE : null;
                      });
                    },
                  ),
                  Center(
                      child: Text(
                    LDLocalizations.labelIsTheEnd,
                    style: Theme.of(context).textTheme.headline6,
                  )),
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
                        child: Text(LDLocalizations.labelIsTheEndDead,
                            style: Theme.of(context).textTheme.headline6)),
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
                        child: Text(LDLocalizations.labelIsTheEndAlive,
                            style: Theme.of(context).textTheme.headline6))
                  ]
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NarrowScaffold(
                            title: "Tree view",
                            actions: [],
                            body: StoryGraphView(story: widget.story)),
                      ),
                    );
                  },
                  icon: Icon(Icons.account_tree_sharp),
                  label: Text(
                    "Tree view",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      story.currentPage.addNextPageWithText(
                          LDLocalizations.optionPlaceHolder);
                    });
                  },
                  icon: Icon(Icons.add_box),
                  label: Text(
                    LDLocalizations.labelOptions,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
            if (story.currentPage.next.length == 0)
              Text(
                LDLocalizations.optionsListEmpty,
                style: Theme.of(context).textTheme.headline6,
              ),
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
                icon: Icon(
                  Icons.add_box,
                ),
                label: Text(LDLocalizations.addNewPassage,
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
            if (story.currentPage.nodes.length == 0)
              Text(LDLocalizations.passageListEmpty),
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
                            title: Text(
                              firstNCharsFromString(node.text, 60),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            leading: imageType == null
                                ? Icon(
                                    Icons.texture,
                                  )
                                : Image(
                                    image: BackgroundImage.getAssetImageForType(
                                        imageType)),
                            onTap: () async {
                              var nodeIndex =
                                  story.currentPage.nodes.indexOf(node);
                              story.currentPage.currentIndex = nodeIndex;
                              await Navigator.pushNamed(
                                context,
                                ExtractEditPassageView.routeName,
                                arguments: EditPassageViewArguments(
                                  page: story.currentPage,
                                ),
                              );

                              await StoryPersistence.instance
                                  .writeStory(widget.story);
                              setState(() {});
                            },
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).primaryColor,
                              ),
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
            BorderedContainer(
              child: SlideableButton(
                child: FatContainer(
                  text: LDLocalizations.startStory,
                ),
                onPress: () async {
                  story.reset();
                  await Navigator.pushNamed(
                    context,
                    ExtractArgumentsGameView.routeName,
                    arguments: GameViewArguments(story: story),
                  );
                  story.reset();
                },
              ),
            )
          ],
        ),
        title: LDLocalizations.createStory,
        actions: [
          AppBarObject(
              text: LDLocalizations.backToStories,
              onTap: () {
                Navigator.pop(context);
              }),
          AppBarObject(
            text: LDLocalizations.save,
            onTap: () => _saveStoryCallback(context),
          ),
          AppBarObject(
              text: LDLocalizations.exportGladStoryToJson,
              onTap: () {
                var json = widget.story.toJson();
                ShareExtend.share(json.toString(), "text");
              }),
          AppBarObject(
              text: LDLocalizations.publishUserStory,
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  PublishUserStory.routeName,
                  arguments: PublishStoryViewArguments(story: story),
                );
              }),
        ]);
  }

  _saveStory(BuildContext context) async {
    await StoryPersistence.instance.writeCreatorStory(widget.story);
    setState(() {});
  }

  _saveStoryCallback(BuildContext context) {
    _saveStory(context);
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

  EditStoryViewArguments({this.story});
}

class ExtractEditStoryViewArguments extends StatelessWidget {
  static const routeName = "/edit_story";

  Widget build(BuildContext context) {
    final EditStoryViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return EditStoryView(
      story: args.story,
    );
  }
}
