import 'package:flutter/material.dart';

class TextEditor extends StatefulWidget {
  final String text;
  final int maxLines;
  final Function(String) onSave;
  final Function(String) onSubmitted;
  final TextEditingController controller;
  final bool showDone;

  TextEditor(
      {this.text,
      this.maxLines = 1,
      @required this.onSave,
      @required this.onSubmitted,
      @required this.controller,
      this.showDone = true});

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      cursorColor: Theme.of(context).textTheme.title.color,
      focusNode: FocusNode(),
      maxLines: widget.maxLines,
      controller: widget.controller,
      style: Theme.of(context).textTheme.title,
      textInputAction:
          widget.showDone ? TextInputAction.done : TextInputAction.next,
      onSubmitted: (text) {
        widget.onSubmitted(text);
      },
      onChanged: (text) {
        widget.onSave(text);
      },
    );
  }
}
