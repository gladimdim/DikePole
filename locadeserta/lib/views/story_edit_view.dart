import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/image_selector.dart';
import 'package:locadeserta/creator/components/node_editor.dart';
import 'package:locadeserta/creator/components/page_next_edit.dart';
import 'package:locadeserta/creator/components/separator_with_button.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';

class StoryEditView extends StatefulWidget {
  final Story story;

  StoryEditView({required this.story});

  @override
  _StoryEditViewState createState() => _StoryEditViewState();
}

class _StoryEditViewState extends State<StoryEditView> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: buildTree(context),
      ),
    );
  }

  List<Widget> buildTree(BuildContext context) {
    final page = widget.story.currentPage;
    List<Widget> widgets = [];
    if (widget.story.root != page) {
      var parent = widget.story.findParentOfPage(page)!;
      var option =
          parent.next.firstWhere((element) => element.nextPage == page);
      widgets.add(
        BorderedContainer(
          child: TextButton.icon(
            icon: Icon(Icons.arrow_upward),
            label: Text(
              option.text!,
              style: Theme.of(context).textTheme.headline6,
            ),
            onPressed: () {
              setState(() {
                var parent = widget.story.findParentOfPage(page);
                if (parent != null) {
                  widget.story.currentPage = parent;
                } else {
                  widget.story.currentPage = widget.story.root;
                }
              });
            },
          ),
        ),
      );
    } else {
      widgets.add(BorderedContainer(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Pochatok"),
      )));
    }
    widgets.addAll(
      page.nodes.map<Widget>(
        (node) {
          var imageType = node.imageType;
          return Column(
            children: [
              Slidable(
                actionPane: SlidableScrollActionPane(),
                child: Row(
                  children: [
                    if (imageType != null)
                      Icon(
                        Icons.image,
                        size: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                    Expanded(
                      flex: 10,
                      child: NodeEditor(
                        node: node,
                      ),
                    ),
                  ],
                ),
                secondaryActions: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        page.removeNode(node);
                      });
                    },
                  ),
                ],
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: node.imageType != null,
                        onChanged: (newValue) {
                          setState(
                            () {
                              if (newValue!) {
                                node.imageType = ImageType.BOAT;
                              } else {
                                node.imageType = null;
                              }
                            },
                          );
                        },
                      ),
                      Icon(
                        Icons.image,
                        size: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                      if (imageType != null)
                        Row(
                          children: [
                            ImageSelector(
                                imageType: imageType,
                                onSelected: (newType) {
                                  setState(() {
                                    node.imageType = newType;
                                  });
                                }),
                            Image(
                              image: BackgroundImage.getAssetImageForType(
                                imageType,
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SeparatorWithButton(
                  button: IconButton(
                    icon: Icon(Icons.add_box_outlined),
                    onPressed: () {
                      setState(() {
                        page.addNodeWithTextAtIndex(
                            "Порожній", page.nodes.indexOf(node) + 1);
                      });
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    if (widgets.isEmpty) {
      widgets.add(
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(
              () {
                page.addNodeWithText("Порожній");
              },
            );
          },
        ),
      );
    }
    if (page.hasNext()) {
      page.next.forEach((nextPagePointer) {
        widgets.add(
          PageNextEdit(
            pageNext: nextPagePointer,
            onDelete: (nextPage) {
              setState(() {
                page.removeNextPage(nextPage);
              });
            },
            onSelect: (PageNext next) {
              setState(() {
                widget.story.goToNextPage(next);
                _scrollController.jumpTo(0);
              });
            },
          ),
        );
      });
    }

    widgets.add(
      SeparatorWithButton(
        button: Container(
          color: Theme.of(context).backgroundColor,
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(LDLocalizations.labelAddBranch),
              IconButton(
                icon: Icon(
                  Icons.account_tree_sharp,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                onPressed: () {
                  setState(
                    () {
                      page.addNextPageWithText("Порожньо");
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    widgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            activeColor: Theme.of(context).primaryColor,
            checkColor: Theme.of(context).backgroundColor,
            value: page.isTheEnd(),
            onChanged: (newValue) {
              setState(
                () {
                  page.endType = newValue! ? EndType.ALIVE : null;
                },
              );
            },
          ),
          Center(
            child: Text(
              LDLocalizations.labelIsTheEnd,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Radio(
            value: EndType.DEAD,
            groupValue: page.endType,
            onChanged: (newValue) {
              setState(() {
                page.endType = EndType.DEAD;
              });
            },
          ),
          Center(
            child: Text(LDLocalizations.labelIsTheEndDead,
                style: Theme.of(context).textTheme.headline6),
          ),
          Radio(
            value: EndType.ALIVE,
            groupValue: page.endType,
            onChanged: (newValue) {
              setState(() {
                page.endType = EndType.ALIVE;
              });
            },
          ),
          Center(
            child: Text(LDLocalizations.labelIsTheEndAlive,
                style: Theme.of(context).textTheme.headline6),
          )
        ],
      ),
    );

    return widgets;
  }
}
