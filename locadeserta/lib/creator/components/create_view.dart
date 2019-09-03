import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components.dart';
import 'package:locadeserta/creator/components/edit_story.dart';
import 'package:locadeserta/creator/story/Story.dart';
import 'package:locadeserta/creator/story/story_builder.dart';

class CreateView extends StatefulWidget {
  final Locale locale;

  @override
  _CreateViewState createState() => _CreateViewState();

  CreateView({this.locale});
}

class _CreateViewState extends State<CreateView> {
  StoryBuilder story;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PRE ALPHA",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Card(
                  elevation: 10.0,
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.book),
                        title: Text('Reuse existing story'),
                      ),
                      CreateMetaStoryView(
                        story: StoryBuilder.fromStory(Story.generate()),
                        onSave: (StoryBuilder newStory) {
                          setState(() {
                            _goToEditStoryView(newStory);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Card(
                  elevation: 10.0,
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.book),
                        title: Text('Create new Story from scratch'),
                      ),
                      CreateMetaStoryView(
                        story: null,
                        onSave: (StoryBuilder newStory) {
                          setState(() {
                            _goToEditStoryView(newStory);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _goToEditStoryView(StoryBuilder story) {
    Navigator.pushNamed(context, ExtractEditStoryViewArguments.routeName,
        arguments: EditStoryViewArguments(story: story, locale: widget.locale));
  }
}

class StoryViewHeader extends StatelessWidget {
  final StoryBuilder story;

  final VoidCallback onEdit;

  StoryViewHeader({this.story, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Title: "),
            Text(story.title),
          ],
        ),
        SizedBox(
          width: 40,
        ),
        SlideableButton(
          child: optionBox(context, "Edit"),
          onPress: onEdit,
        ),
      ],
    );
  }
}

class CreateMetaStoryView extends StatefulWidget {
  final Function(StoryBuilder story) onSave;
  final StoryBuilder story;

  CreateMetaStoryView({@required this.onSave, this.story});

  @override
  _CreateMetaStoryViewState createState() => _CreateMetaStoryViewState();
}

class _CreateMetaStoryViewState extends State<CreateMetaStoryView> {
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
              hintText: "Enter story title",
              labelText: "Title: ",
            ),
            initialValue: widget.story == null ? "" : widget.story.title,
            onSaved: (value) {
              _title = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.description),
              hintText: "Enter story description",
              labelText: "Description: ",
            ),
            onSaved: (value) {
              _description = value;
            },
            initialValue: widget.story == null ? "" : widget.story.description,
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.title),
              hintText: "List of authors separated by comma",
              labelText: "Authors: ",
            ),
            onSaved: (value) {
              _authors = value;
            },
            initialValue: widget.story == null ? "" : widget.story.authors[0],
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: RaisedButton(
              onPressed: () {
                _formKey.currentState.save();
                var newStory =
                    widget.story == null ? StoryBuilder() : widget.story;
                newStory.title = _title;
                newStory.description = _description;
                newStory.authors = [_authors];
                widget.onSave(newStory);
              },
              child: Text("Save"),
            ),
          )
        ],
      ),
    );
  }
}
