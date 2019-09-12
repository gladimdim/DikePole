import 'package:flutter/material.dart';
import 'package:locadeserta/creator/story/story.dart';

class EditPassageView extends StatelessWidget {
  final PageNode node;

  EditPassageView({this.node});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(node.text),
      appBar: AppBar(
        title: const Text("Editing passage"),
      ),
    );
  }
}

class EditPassageViewArguments {
  final PageNode node;

  EditPassageViewArguments({this.node});
}

class ExtractEditPassageView extends StatelessWidget {
  static const routeName = "/editPassage";

  Widget build(BuildContext context) {
    final EditPassageViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return EditPassageView(
      node: args.node,
    );
  }
}
