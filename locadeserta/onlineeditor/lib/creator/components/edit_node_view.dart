import 'package:flutter/material.dart';
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/animations/slideable_button.dart';
import 'package:onlineeditor/components/bordered_container.dart';
import 'package:onlineeditor/creator/components/fat_container.dart';
import 'package:onlineeditor/creator/components/image_selector.dart';
import 'package:onlineeditor/creator/components/text_editor.dart';
import 'package:onlineeditor/creator/story/story.dart';
import 'package:onlineeditor/models/background_image.dart';

class EditNodeView extends StatefulWidget {
  final PageNode node;
  final VoidCallback onFinished;
  final bool isLastNode;

  EditNodeView({@required this.node, this.onFinished, this.isLastNode = false});

  @override
  _EditNodeViewState createState() => _EditNodeViewState();
}

class _EditNodeViewState extends State<EditNodeView> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BorderedContainer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: TextEditor(
                  controller: _setTextToTextEditingController(widget.node.text),
                  text: widget.node.text,
                  maxLines: 20,
                  onSave: (text) {
                    widget.node.text = text;
                  },
                  onSubmitted: (text) {
                    widget.node.text = text;
                    widget.onFinished();
                  },
                  showDone: widget.isLastNode,
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Text(LDLocalizations.passageWillHaveImage),
                    Checkbox(
                      value: widget.node.imageType != null,
                      onChanged: (newValue) {
                        setState(() {
                          if (newValue) {
                            widget.node.imageType = ImageType.BOAT;
                          } else {
                            widget.node.imageType = null;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (widget.node.imageType != null)
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Text(LDLocalizations.selectImageForPassage),
                      SizedBox(
                        width: 20,
                      ),
                      ImageSelector(
                        imageType: widget.node.imageType,
                        onSelected: (newImageType) {
                          setState(() {
                            widget.node.imageType = newImageType;
                          });
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _setTextToTextEditingController(String text) {
    controller.text = text;
    return controller;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}

class TextEditorWithButton extends StatefulWidget {
  final String text;
  final int maxLines;
  final Function(String) onSave;

  TextEditorWithButton({this.text, this.onSave, this.maxLines = 25});

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditorWithButton> {
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
    return Column(
      children: <Widget>[
        BorderedContainer(
          child: EditableText(
            cursorColor: Colors.black,
            backgroundCursorColor: Colors.white,
            focusNode: FocusNode(),
            maxLines: widget.maxLines,
            controller: _controller,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SlideableButton(
            child: FatContainer(
              text: LDLocalizations.save,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPress: () {
              widget.onSave(_controller.text);
            },
          ),
        )
      ],
    );
  }
}
