import 'package:flutter/material.dart';

class TextEditor extends StatefulWidget {
  final String text;
  final int maxLines;
  final Function(String) onSave;
  final Function(String) onSubmitted;
  final TextEditingController controller;

  TextEditor({this.text, this.maxLines = 1, this.onSave, this.onSubmitted, this.controller});

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  TextEditingController _controller = TextEditingController();

  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        keyboardType: TextInputType.multiline,
        cursorColor: Colors.black,
        focusNode: FocusNode(),
        maxLines: widget.maxLines,
        controller: widget.controller == null ? _controller : widget.controller,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (text) {
          FocusScope.of(context).unfocus();
          widget.onSubmitted(text);
        },
        onChanged: (text) {
          widget.onSave(text);
        }
    );
  }
}
