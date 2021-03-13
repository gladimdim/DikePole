import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/creator/components/node_editor.dart';
import 'package:locadeserta/models/Localizations.dart';

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
        return Column(
          children: [
            Slidable(
              actionPane: SlidableBehindActionPane(),
              child: NodeEditor(
                node: node,
              ),
              secondaryActions: [
                IconSlideAction(
                  icon: Icons.delete,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    page.addNodeWithTextAtIndex(
                        "Empty", page.nodes.indexOf(node) + 1);
                  });
                },
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
            setState(() {
              page.addNodeWithText("Empty");
            });
          },
        ),
      );
    }
    return widgets;
  }
}
