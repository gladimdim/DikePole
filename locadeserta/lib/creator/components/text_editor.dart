import 'package:flutter/material.dart';

class TextEditor extends StatefulWidget {
  final String text;
  final int maxLines;
  final Function(String) onSave;

  TextEditor({this.text, this.maxLines = 1, this.onSave});

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  TextEditingController _controller = TextEditingController();

  initState() {
    _controller.text = widget.text;
    super.initState();
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      cursorColor: Colors.black,
      focusNode: FocusNode(),
      maxLines: widget.maxLines,
      controller: _controller,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      textInputAction: TextInputAction.done,
      onSubmitted: (text) {
        widget.onSave(text);
      }
    );
  }
}
