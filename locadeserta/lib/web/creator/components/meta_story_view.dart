import 'package:flutter/material.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:flutter/services.dart';
import 'package:locadeserta/web/models/background_image.dart';

class MetaStoryView extends StatefulWidget {
  final Function(Story story) onSave;
  final Story story;
  final Function(Story story) onDelete;
  final Function(Story story) onEdit;

  MetaStoryView({this.story, this.onSave, this.onDelete, this.onEdit});

  @override
  _MetaStoryViewState createState() => _MetaStoryViewState();
}

class _MetaStoryViewState extends State<MetaStoryView> {
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      return EditMetaStoryView(
          story: widget.story,
          onSave: (story) {
            setState(() {
              editMode = false;
            });
            widget.onSave(story);
          },
          onDelete: widget.onDelete,
          onEdit: widget.onEdit,
          onToggleEdit: () {
            setState(() {
              editMode = !editMode;
            });
          });
    } else {
      return Column(
        children: <Widget>[
          SlideableButton(
            onPress: () {
              setState(() {
                editMode = true;
              });
            },
            child: FatContainer(
              text: widget.story.title,
            ),
          ),
        ],
      );
    }
  }
}

class EditMetaStoryView extends StatefulWidget {
  final Function(Story story) onSave;
  final Story story;
  final Function(Story story) onEdit;
  final Function(Story story) onDelete;
  final VoidCallback onToggleEdit;

  EditMetaStoryView(
      {this.onDelete,
      @required this.onSave,
      this.story,
      this.onEdit,
      this.onToggleEdit});

  @override
  _EditMetaStoryViewState createState() => _EditMetaStoryViewState();
}

class _EditMetaStoryViewState extends State<EditMetaStoryView> {
  final _formKey = GlobalKey<FormState>();

  String _title;

  String _description;

  String _authors;

  int _year;

  @override
  Widget build(BuildContext context) {
    var year;

    if (widget.story != null && widget.story.year != null) {
      year = widget.story.year;
    } else {
      year = 1620;
    }

    return Column(
      children: <Widget>[
        if (widget.story != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.story.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.title),
                  hintText: LDLocalizations.enterStoryTitle,
                  labelText: LDLocalizations.labelStoryTitle,
                ),
                initialValue: widget.story == null ? "" : widget.story.title,
                onSaved: (value) {
                  _title = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.description),
                  hintText: LDLocalizations.hintDescription,
                  labelText: LDLocalizations.description,
                ),
                onSaved: (value) {
                  _description = value;
                },
                minLines: 1,
                maxLines: 5,
                initialValue:
                    widget.story == null ? "" : widget.story.description,
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.title),
                  hintText: LDLocalizations.listOfAuthors,
                  labelText: LDLocalizations.labelAuthors,
                ),
                onSaved: (value) {
                  _authors = value;
                },
                initialValue: widget.story == null ? "" : widget.story.authors,
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  hintText: LDLocalizations.hintFieldYear,
                  labelText: LDLocalizations.labelYear,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                onSaved: (value) {
                  _year = int.parse(value);
                },
                initialValue: "$year",
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      _formKey.currentState.save();
                      var story;
                      if (widget.story == null) {
                        story = Story(
                          title: _title,
                          description: _description,
                          authors: _authors,
                          root: Page.generate(),
                          imageResolver: BackgroundImage.getRandomImageForType,
                        );
                      } else {
                        story = widget.story;
                        story.title = _title;
                        story.description = _description;
                        story.authors = _authors;
                        story.year = _year;
                      }
                      widget.onSave(story);
                    },
                  ),
                ),
                if (widget.onEdit != null)
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        widget.onEdit(widget.story);
                      },
                    ),
                  ),
                if (widget.onEdit != null)
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          widget.onToggleEdit();
                        });
                      },
                    ),
                  ),
                if (widget.onDelete != null)
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        widget.onDelete(widget.story);
                      },
                    ),
                  ),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
