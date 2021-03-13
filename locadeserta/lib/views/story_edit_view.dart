import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/components/dash_painter.dart';
import 'package:locadeserta/creator/components/node_editor.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';

class StoryEditView extends StatefulWidget {
  final Story story;

  StoryEditView({required this.story});

  @override
  _StoryEditViewState createState() => _StoryEditViewState();
}

class _StoryEditViewState extends State<StoryEditView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: buildTree(context),
      ),
    );
  }

  List<Widget> buildTree(BuildContext context) {
    final page = widget.story.currentPage;
    List<Widget> widgets = page.nodes.map<Widget>(
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
                Icon(
                  Icons.delete,
                  color: Theme.of(context).primaryColor,
                ),
              ],
              actions: [
                if (imageType != null)
                  Image(
                    image: BackgroundImage.getAssetImageForType(imageType),
                  )
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 32,
                    child: CustomPaint(
                      foregroundPainter: DashPainter(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 42,
                    color: Theme.of(context).backgroundColor,
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.add_box_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            page.addNodeWithTextAtIndex(
                                "Empty", page.nodes.indexOf(node) + 1);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ).toList();
    if (widgets.isEmpty) {
      widgets.add(
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(
              () {
                page.addNodeWithText("Empty");
              },
            );
          },
        ),
      );
    }
    return widgets;
  }
}
