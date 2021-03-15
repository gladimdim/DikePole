import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';

class NodeEditor extends StatelessWidget {
  final PageNode node;
  final TextEditingController _textController = TextEditingController();
  NodeEditor({required this.node}) {
    _textController.text = node.text ?? "Empty";
    _textController.addListener(_textChanged);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      minLines: 1,
      maxLines: null,
      controller: _textController,
    );
  }

  void _textChanged() {
    node.text = _textController.text;
  }
}
