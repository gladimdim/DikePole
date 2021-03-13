import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';

class NodeEditor extends StatelessWidget {
  final PageNode node;
  final TextEditingController _textController = TextEditingController();
  NodeEditor({required this.node}) {
    _textController.text = node.text ?? "Empty";
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      minLines: 1,
      maxLines: null,
      controller: _textController,
    );
  }
}
