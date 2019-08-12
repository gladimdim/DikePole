import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/story/Story.dart';

class CreateView extends StatefulWidget {
  final Locale locale;

  @override
  _CreateViewState createState() => _CreateViewState();

  CreateView({this.locale});
}

class _CreateViewState extends State<CreateView> {
  bool showCreateMeta = true;
  Story story;

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
                        subtitle:
                            Text('Введіть основні поля про вашу історію.'),
                      ),
                      CreateMetaStoryView(
                        story: story,
                        onSave: (Story newStory) {
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
          ],
        ),
      ),
    );
  }
}

class StoryViewHeader extends StatelessWidget {
  final Story story;

  final VoidCallback onEdit;

  StoryViewHeader({this.story, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(story.title),
        Text(story.authors[0]),
        RaisedButton(
          onPressed: onEdit,
          child: Text("Редагувати"),
        )
      ],
    );
  }
}

class CreateMetaStoryView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _description;
  String _authors;
  Function(Story story) onSave;
  Story story;

  CreateMetaStoryView({@required this.onSave, this.story});

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
              initialValue: story == null ? "" : story.title,
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
              initialValue: story == null ? "" : story.description,
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
              initialValue: story == null ? "" : story.authors[0],
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: RaisedButton(
                onPressed: () {
                  _formKey.currentState.save();
                  var story = Story(
                    title: _title,
                    description: _description,
                    authors: [_authors],
                    passages: [
                      PassageContinue(
                        text: "test",
                        id: 0,
                        next: 1,
                      ),
                    ],
                  );
                  onSave(story);
                },
                child: Text("Зберегти"),
              ),
            )
          ],
        ));
  }
}
