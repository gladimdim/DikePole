import 'package:flutter/material.dart';
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/creator/components/edit_node_view.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';

class EditNodeSequence extends StatefulWidget {
  final Page page;
  final int startIndex;
  static const routeName = "/editPassages";

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
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: EditNodeView(
            node: widget.page.getCurrentNode(),
            onFinished: () {
              setState(() {
                if (!widget.page.hasNext()) {
                  widget.page.addNodeWithText("");
                }
                widget.page.nextNode();
              });
            },
            isLastNode: !widget.page.hasNext(),
          )),
      appBar: AppBar(
        title: Text(LDLocalizations.editingPassage),
      ),
    );
  }
}
