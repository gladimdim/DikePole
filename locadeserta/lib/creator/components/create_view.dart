import 'package:flutter/material.dart';
import 'package:locadeserta/creator/components/edit_story.dart';
import 'package:locadeserta/creator/story/persistence.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/waiting_screen.dart';
import 'package:async/async.dart';

class CreateView extends StatefulWidget {
  final Locale locale;
  final Auth auth;

  @override
  _CreateViewState createState() => _CreateViewState();

  CreateView({this.locale, @required this.auth});
}

class _CreateViewState extends State<CreateView> {
  Story story;
  AsyncMemoizer _storyBuilderCatalogMemo = AsyncMemoizer();
  final AsyncMemoizer _currentUserMemo = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LDLocalizations.of(context).createStory,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
          future: _currentUser(),
          builder: (context, snapshot) {
            User user = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return WaitingScreen();
                break;
              case ConnectionState.done:
                return _buildStoryView(context, user);
              default:
                return WaitingScreen();
            }
          }),
    );
  }

  _buildStoryView(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Center(
            child: Card(
              elevation: 10.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text(LDLocalizations.of(context).createStory),
                  ),
                  CreateMetaStoryView(
                    story: null,
                    onSave: (Story newStory) {
                      setState(() {
                        _goToEditStoryView(newStory);
                      });
                    },
                    onDelete: null,
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: _fetchData(user),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return WaitingScreen();
                  break;
                case ConnectionState.done:
                  if (snapshot.data == null) {
                    return Container();
                  } else {
                    List<Story> storyBuilders = snapshot.data;
                    return Column(
                      children: _createStoryCards(storyBuilders, user),
                    );
                  }
                  break;
              }
              return Container();
            },
          )
        ],
      )),
    );
  }

  Future _fetchData(User user) {
    return _storyBuilderCatalogMemo.runOnce(() async {
      return StoryPersistence.instance.getUserStories(user);
    });
  }

  Future _currentUser() {
    return _currentUserMemo.runOnce(() async {
      return await widget.auth.currentUser();
    });
  }

  List<Widget> _createStoryCards(List<Story> storyBuilders, User user) {
    return storyBuilders
        .map((storyBuilder) => _createStoryCard(storyBuilder, user))
        .toList();
  }

  Widget _createStoryCard(Story story, User user) {
    return Center(
      child: Card(
        elevation: 10.0,
        child: CreateMetaStoryView(
          story: story,
          onSave: (Story newStory) {
            setState(() {
              _goToEditStoryView(newStory);
            });
          },
          onDelete: (Story story) async {
            await _deleteStory(user, story);
            setState(() {
              _storyBuilderCatalogMemo = AsyncMemoizer();
            });
          },
        ),
      ),
    );
  }

  _goToEditStoryView(Story story) {
    Navigator.pushNamed(context, ExtractEditStoryViewArguments.routeName,
        arguments: EditStoryViewArguments(story: story, locale: widget.locale));
  }

  _deleteStory(User user, Story story) async {
    return await StoryPersistence.instance.deleteStory(user, story);
  }
}

class StoryViewHeader extends StatelessWidget {
  final Story story;

  final VoidCallback onEdit;

  StoryViewHeader({this.story, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              LDLocalizations.of(context).labelStoryTitle,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              story.title,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class CreateMetaStoryView extends StatefulWidget {
  final Function(Story story) onSave;
  final Story story;
  final Function(Story story) onDelete;

  CreateMetaStoryView({this.onDelete, @required this.onSave, this.story});

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
              hintText: LDLocalizations.of(context).enterStoryTitle,
              labelText: LDLocalizations.of(context).labelStoryTitle,
            ),
            initialValue: widget.story == null ? "" : widget.story.title,
            onSaved: (value) {
              _title = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.description),
              hintText: LDLocalizations.of(context).hintDescription,
              labelText: LDLocalizations.of(context).description,
            ),
            onSaved: (value) {
              _description = value;
            },
            initialValue: widget.story == null ? "" : widget.story.description,
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.title),
              hintText: LDLocalizations.of(context).listOfAuthors,
              labelText: LDLocalizations.of(context).labelAuthors,
            ),
            onSaved: (value) {
              _authors = value;
            },
            initialValue: widget.story == null ? "" : widget.story.authors,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.all(4.0),
              child: FlatButton.icon(
                icon: Icon(Icons.edit),
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
                label: Text(LDLocalizations.of(context).edit),
              ),
            ),
            if (widget.onDelete != null)
              Padding(
                padding: EdgeInsets.all(4.0),
                child: FlatButton.icon(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    widget.onDelete(widget.story);
                  },
                  label: Text(LDLocalizations.of(context).remove),
                ),
              ),
          ]),
        ],
      ),
    );
  }
}
