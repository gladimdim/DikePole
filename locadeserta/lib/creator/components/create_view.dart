import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:locadeserta/InheritedAuth.dart';

import 'package:locadeserta/creator/components/edit_story.dart';
import 'package:locadeserta/creator/components/fat_button.dart';
import 'package:locadeserta/creator/story/persistence.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/import_gladstories_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/waiting_screen.dart';
import 'package:locadeserta/animations/slideable_button.dart';

class CreateView extends StatefulWidget {

  @override
  _CreateViewState createState() => _CreateViewState();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SlideableButton(
              onPress: () async {
                await Navigator.pushNamed(context, ImportGladStoryView.routeName);
                _resetStoryBuilderFuture();
              },
              child: FatButton(
                text: LDLocalizations.of(context).labelImport,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: _currentUser(context),
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
            ),
          ],
        ),
      ),
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
                    onSave: (Story newStory) async {
                      await StoryPersistence.instance
                          .writeStory(user, newStory);
                      _resetStoryBuilderFuture();
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
                      children: _createStoryCards(storyBuilders, user, context),
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

  _resetStoryBuilderFuture() {
    setState(() {
      _storyBuilderCatalogMemo = AsyncMemoizer();
    });
  }

  Future _currentUser(BuildContext context) {
    return _currentUserMemo.runOnce(() async {
      var auth = InheritedAuth.of(context).auth;
      return await auth.currentUser();
    });
  }

  List<Widget> _createStoryCards(List<Story> storyBuilders, User user, context) {
    return storyBuilders
        .map((storyBuilder) => _createStoryCard(storyBuilder, user, context))
        .toList();
  }

  Widget _createStoryCard(Story story, User user, context) {
    return Center(
      child: Card(
        elevation: 10.0,
        child: CreateMetaStoryView(
          story: story,
          onSave: (Story newStory) {
            _goToEditStoryView(newStory, context);
          },
          onDelete: (Story story) async {
            await _deleteStory(user, story);
            _resetStoryBuilderFuture();
          },
        ),
      ),
    );
  }

  _goToEditStoryView(Story story, context) async {
    await Navigator.pushNamed(context, ExtractEditStoryViewArguments.routeName,
        arguments: EditStoryViewArguments(story: story));
    _resetStoryBuilderFuture();
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
    var editMode = widget.onDelete != null;
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
                  if (!editMode) {
                    setState(() {
                      _formKey.currentState.reset();
                    });
                  }
                  widget.onSave(story);
                },
                label: Text(editMode
                    ? LDLocalizations.of(context).edit
                    : LDLocalizations.of(context).createStory),
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
