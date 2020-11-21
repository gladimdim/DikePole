import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/creator/components/image_selector.dart';
import 'package:locadeserta/creator/components/text_editor.dart';
import 'package:locadeserta/models/Localizations.dart';

class EditNodeView extends StatefulWidget {
  final PageNode node;
  final VoidCallback onFinished;
  final bool isLastNode;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onAddNewNextPressed;

  EditNodeView({
    @required this.node,
    this.onFinished,
    this.isLastNode = false,
    this.onNextPressed,
    this.onPreviousPressed,
    this.onDeletePressed,
    this.onAddNewNextPressed,
  });

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
                flex: 4,
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
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BorderedContainer(
                            child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: widget.onPreviousPressed,
                          ),
                        )),
                        BorderedContainer(
                            child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: widget.onDeletePressed,
                          ),
                        )),
                        BorderedContainer(
                            child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: IconButton(
                            icon: Icon(Icons.create_new_folder),
                            onPressed: widget.onAddNewNextPressed,
                          ),
                        )),
                        BorderedContainer(
                            child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: widget.onNextPressed,
                          ),
                        )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          LDLocalizations.passageWillHaveImage,
                          style: Theme.of(context).textTheme.headline6,
                        ),
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
                  ],
                ),
              ),
              if (widget.node.imageType != null)
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Text(
                        LDLocalizations.selectImageForPassage,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
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
            backgroundCursorColor: Theme.of(context).backgroundColor,
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
