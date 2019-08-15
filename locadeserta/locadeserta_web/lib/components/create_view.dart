import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/animations/slideable_button_web.dart';
import 'package:locadeserta_web/components/components.dart';
import 'package:locadeserta_web/components/create_passage.dart';
import 'package:locadeserta_web/story/Story.dart';
import 'package:locadeserta_web/story/story_builder.dart';

class CreateView extends StatefulWidget {
  final Locale locale;

  @override
  _CreateViewState createState() => _CreateViewState();

  CreateView({this.locale});
}

class _CreateViewState extends State<CreateView> {
  bool showCreateMeta = true;
  StoryBuilder story;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            if (showCreateMeta)
              Center(
                child: Card(
                  elevation: 10.0,
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.album),
                        title: Text('Створення нової історії'),
                        subtitle: Text('Додайте більше деталей.'),
                      ),
                      CreateMetaStoryView(
                        story: story,
                        onSave: (StoryBuilder newStory) {
                          setState(() {
                            if (story == null) {
                              story = newStory;
                            } else {
                              story.title = newStory.title;
                              story.description = newStory.description;
                              story.authors = newStory.authors;
                            }
                            showCreateMeta = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            if (!showCreateMeta)
              StoryViewHeader(
                story: story,
                onEdit: () {
                  setState(() {
                    showCreateMeta = true;
                  });
                },
              ),
            if (!showCreateMeta)
              CreatePassage(
                onAdd: (PassageTypes type) {
                  setState(() {
                    story.addPassage(passageBuilderFromType(type));
                  });
                },
              ),
            if (!showCreateMeta && story != null)
              ...story.getPassages().map(
                    (passageBuilderBase) => passageBuilderBase.toWidget(story),
              ),
            if (!showCreateMeta)
              SlideableButton(
                child: styledContainerForButton(
                  context, "Export"
                ),
                onPress: () {
                  print(story.toModel().toJson());
                },
              )
          ],
        ),
      ),
    );
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
            Text("Назва: "),
            Text(story.title),
          ],
        ),
        SizedBox(
          width: 40,
        ),
        SlideableButton(
          child: styledContainerForButton(context, "Редагувати"),
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
              hintText: "Введіть назву історії",
              labelText: "Назва: ",
            ),
            initialValue: widget.story == null ? "" : widget.story.title,
            onSaved: (value) {
              _title = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.description),
              hintText: "Введіть описання історії",
              labelText: "Описання: ",
            ),
            onSaved: (value) {
              _description = value;
            },
            initialValue: widget.story == null ? "" : widget.story.description,
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.title),
              hintText: "Список авторів через кому",
              labelText: "Автори: ",
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
                var story = StoryBuilder(
                  title: _title,
                  description: _description,
                  authors: [_authors],
                );
                widget.onSave(story);
              },
              child: Text("Зберегти"),
            ),
          )
        ],
      ),
    );
  }
}
