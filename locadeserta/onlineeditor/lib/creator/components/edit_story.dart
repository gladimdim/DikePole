import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:onlineeditor/animations/slideable_button.dart';
import 'package:onlineeditor/components/bordered_container.dart';
import 'package:onlineeditor/components/narrow_scaffold.dart';
import 'package:onlineeditor/creator/components/edit_node_view.dart';
import 'package:onlineeditor/creator/components/fat_button.dart';
import 'package:onlineeditor/creator/components/game_view.dart';
import 'package:onlineeditor/creator/components/text_editor.dart';
import 'package:onlineeditor/creator/story/story.dart';
import 'package:onlineeditor/creator/utils/utils.dart';
import 'package:onlineeditor/models/background_image.dart';

class EditStoryView extends StatefulWidget {
  final String storyUrl;

  EditStoryView({@required this.storyUrl});

  @override
  _EditStoryViewState createState() => _EditStoryViewState();
}

class _EditStoryViewState extends State<EditStoryView> {
  Map<int, bool> expandedIndexes = Map();
  Map<PageNext, TextEditingController> _textControllers = {};
  Story story;

  Future<http.Response> fetchStory() {
    return http.get(widget.storyUrl);
  }

  final AsyncMemoizer _fetchMemo = AsyncMemoizer();

  fetchFuture() {
    return _fetchMemo.runOnce(fetchStory);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchFuture(),
        builder: (context, snapshot) {
          print("State: ${snapshot.connectionState}");
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Container();
              break;
            case ConnectionState.done:
              if (story == null) {
                story = Story.fromJson(snapshot.data.body);
              }
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
                                  label: Text("Back"),
                                  onPressed: () {
                                    setState(() {
                                      var parent = story
                                          .findParentOfPage(story.currentPage);
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
                          Center(child: Text("Is the end")),
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
                            Center(child: Text("Is dead")),
                            Radio(
                              value: EndType.ALIVE,
                              groupValue: story.currentPage.endType,
                              onChanged: (newValue) {
                                setState(() {
                                  story.currentPage.endType = EndType.ALIVE;
                                });
                              },
                            ),
                            Center(child: Text("Is Alive"))
                          ]
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton.icon(
                        onPressed: () {
                          setState(() {
                            story.currentPage.addNextPageWithText("Dummy");
                          });
                        },
                        icon: Icon(Icons.add_box),
                        label: Text("Options"),
                      ),
                    ),
                    if (story.currentPage.next.length == 0)
                      Text("options are empty"),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                        print("pressed details");
                                        setState(() {
                                          story.goToNextPage(next);
                                        });
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          story.currentPage
                                              .removeNextPage(next);
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
                        label: Text("Add new passage"),
                      ),
                    ),
                    if (story.currentPage.nodes.length == 0)
                      Text("Passage list is empty"),
                    Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: Column(
                            children:
                                story.currentPage.nodes.reversed.map((node) {
                              var imageType = node.imageType;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BorderedContainer(
                                  child: ListTile(
                                    title: Text(
                                        firstNCharsFromString(node.text, 60)),
                                    leading: imageType == null
                                        ? Icon(Icons.texture)
                                        : Image(
                                            image: BackgroundImage
                                                .getAssetImageForType(
                                                    imageType)),
                                    onTap: () async {
                                      print("going to node ${node.text}");
                                      await Navigator.pushNamed(
                                        context,
                                        ExtractEditPassageView.routeName,
                                        arguments: node,
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
                      child: FatButton(
                        text: "Start story",
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPress: () async {
                        story.reset();
                        await Navigator.pushNamed(
                          context,
                          ExtractArgumentsGameView.routeName,
                          arguments: story,
                        );
                        story.reset();
                      },
                    )
                  ],
                ),
                title: "Create story",
                actions: [],
              );
          }
          return Container();
        });
  }

  @override
  void dispose() {
    super.dispose();
    _textControllers.forEach((key, controller) {
      controller.dispose();
    });
  }
}
