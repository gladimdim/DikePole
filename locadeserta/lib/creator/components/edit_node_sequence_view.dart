import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart' as gse;
import 'package:locadeserta/creator/components/edit_node_view.dart';
import 'package:locadeserta/models/Localizations.dart';

class EditNodeSequence extends StatefulWidget {
  final gse.Page page;
  final int startIndex;

  EditNodeSequence({@required this.page, this.startIndex = 0});

  @override
  _EditNodeSequenceState createState() => _EditNodeSequenceState();
}

class _EditNodeSequenceState extends State<EditNodeSequence> {
  int currentIndex;

  @override
  void initState() {
    super.initState();
    widget.page.currentIndex = widget.startIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: widget.page.nodes.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditNodeView(
                node: widget.page.getCurrentNode(),
                onFinished: () {
                  setState(() {
                    moveToNextNode();
                  });
                },
                isLastNode: !widget.page.hasNextNode(),
                onNextPressed: () {
                  setState(() {
                    moveToNextNode();
                  });
                },
                onPreviousPressed: () {
                  setState(() {
                    moveToPreviousNode();
                  });
                },
                onDeletePressed: widget.page.nodes.isNotEmpty
                    ? () {
                        setState(() {
                          deleteNode();
                        });
                      }
                    : null,
              ))
          : Center(child: Text(LDLocalizations.labelNoPassagesAvailable)),
      appBar: AppBar(
        title: Text(
          LDLocalizations.editingPassage,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  void moveToNextNode() {
    if (!widget.page.hasNextNode()) {
      widget.page.addNodeWithText("");
    }
    widget.page.nextNode();
  }

  void moveToPreviousNode() {
    widget.page.previousNode();
  }

  void deleteNode() {
    widget.page.deleteCurrentNode();
  }
}

class EditPassageViewArguments {
  final gse.Page page;
  final int startIndex;

  EditPassageViewArguments({this.page, this.startIndex = 0});
}

class ExtractEditPassageView extends StatelessWidget {
  static const routeName = "/editPassages";

  Widget build(BuildContext context) {
    final EditPassageViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return EditNodeSequence(
      page: args.page,
      startIndex: args.startIndex,
    );
  }
}
