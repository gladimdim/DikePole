import 'package:flutter/material.dart';
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/creator/components/edit_node_view.dart';
import 'package:onlineeditor/creator/story/story.dart';

class EditNodeSequence extends StatefulWidget {
  final Page page;
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
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: EditNodeView(
            node: widget.page.getCurrentNode(),
            onFinished: () {
              if (widget.page.hasNext()) {
                setState(() {
                  widget.page.nextNode();
                });
              } else {
                Navigator.pop(context);
              }
            },
            isLastNode: !widget.page.hasNext(),
          )),
      appBar: AppBar(
        title: Text(LDLocalizations.editingPassage),
      ),
    );
  }
}

class EditPassageViewArguments {
  final Page page;
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
