import 'package:flutter/material.dart';
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/animations/slideable_button.dart';
import 'package:onlineeditor/creator/components/fat_container.dart';
import 'package:onlineeditor/creator/story/story.dart';

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
      );
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

  EditMetaStoryView(
      {this.onDelete, @required this.onSave, this.story, this.onEdit});

  @override
  _EditMetaStoryViewState createState() => _EditMetaStoryViewState();
}

class _EditMetaStoryViewState extends State<EditMetaStoryView> {
  final _formKey = GlobalKey<FormState>();

  String _title;

  String _description;

  String _authors;

  @override
  Widget build(BuildContext context) {
    return Form(
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
            initialValue: widget.story == null ? "" : widget.story.description,
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
                    );
                  } else {
                    story = widget.story;
                    story.title = _title;
                    story.description = _description;
                    story.authors = _authors;
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
    );
  }
}
