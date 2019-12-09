import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/creator/components/edit_meta_story_view.dart';
import 'package:locadeserta/creator/components/fat_container.dart';

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
        },
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
