import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/fat_button.dart';
import 'package:locadeserta/creator/components/image_selector.dart';
import 'package:locadeserta/creator/components/text_editor.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';

class EditNodeView extends StatefulWidget {
  final PageNode node;

  EditNodeView({this.node});

  @override
  _EditNodeViewState createState() => _EditNodeViewState();
}

class _EditNodeViewState extends State<EditNodeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BorderedContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: TextEditor(
                      text: widget.node.text,
                      maxLines: 20,
                      onSave: (text) {
                        widget.node.text = text;
                      },
                      onSubmitted: (text) {
                        widget.node.text = text;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Text(LDLocalizations.of(context).passageWillHaveImage),
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
                          Text(LDLocalizations.of(context).selectImageForPassage),
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
        ),
      ),
      appBar: AppBar(
        title: Text(LDLocalizations.of(context).editingPassage),
      ),
    );
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
            child: FatButton(
              text: LDLocalizations.of(context).save,
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

class EditPassageViewArguments {
  final PageNode node;

  EditPassageViewArguments({this.node});
}

class ExtractEditPassageView extends StatelessWidget {
  static const routeName = "/editPassage";

  Widget build(BuildContext context) {
    final EditPassageViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return EditNodeView(
      node: args.node,
    );
  }
}
