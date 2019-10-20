import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/creator/story/persistence.dart';
import 'package:onlineeditor/creator/story/story.dart';
import 'package:onlineeditor/models/LDUser.dart';
import 'package:onlineeditor/views/inherited_auth.dart';
import 'package:onlineeditor/waiting_screen.dart';

class CatalogGladStoryView extends StatefulWidget {
  @override
  _CatalogGladStoryViewState createState() => _CatalogGladStoryViewState();

  static const routeName = "/catalog_view";
}

class _CatalogGladStoryViewState extends State<CatalogGladStoryView> {
  Story story;
  AsyncMemoizer _storyBuilderCatalogMemo = AsyncMemoizer();
  final AsyncMemoizer _currentUserMemo = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return _buildStoryView(context, InheritedAuth.of(context).auth.getUser());
  }

  _buildStoryView(BuildContext context, LDUser user) {
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
                    title: Text(LDLocalizations.createStory),
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

  Future _fetchData(LDUser user) {
    return _storyBuilderCatalogMemo.runOnce(() async {
      return StoryPersistence.instance.getUserStories(user);
    });
  }

  _resetStoryBuilderFuture() {
    setState(() {
      _storyBuilderCatalogMemo = AsyncMemoizer();
    });
  }

  List<Widget> _createStoryCards(
      List<Story> storyBuilders, LDUser user, context) {
    return storyBuilders
        .map((storyBuilder) => _createStoryCard(storyBuilder, user, context))
        .toList();
  }

  Widget _createStoryCard(Story story, LDUser user, context) {
    return Center(
      child: Card(
        elevation: 10.0,
        child: CreateMetaStoryView(
          story: story,
          onSave: (Story newStory) {
            _goToEditStoryView(newStory, context);
          },
        ),
      ),
    );
  }

  _goToEditStoryView(Story story, context) async {
    await Navigator.pushNamed(
      context,
      "/editStories",
      arguments: story,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              LDLocalizations.labelStoryTitle,
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
                    ? LDLocalizations.edit
                    : LDLocalizations.createStory),
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
                  label: Text(LDLocalizations.remove),
                ),
              ),
          ]),
        ],
      ),
    );
  }
}
