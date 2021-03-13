import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';

class PageNextEditor extends StatelessWidget {
  final PageNext next;
  final TextEditingController _textController = TextEditingController();
  PageNextEditor({required this.next}) {
    _textController.text = next.text ?? "Порожньо";
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
}
