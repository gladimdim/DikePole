import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components.dart';
import 'package:locadeserta/creator/components/edit_story.dart';
import 'package:locadeserta/creator/story/persistence.dart';
import 'package:locadeserta/creator/story/story_builder.dart';
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
  StoryBuilder story;
  AsyncMemoizer _storyBuilderCatalogMemo = AsyncMemoizer();
  final AsyncMemoizer _currentUserMemo = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ALPHA VERSION",
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
                    onSave: (StoryBuilder newStory) {
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
                    List<StoryBuilder> storyBuilders = snapshot.data;
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

  List<Widget> _createStoryCards(List<StoryBuilder> storyBuilders, User user) {
    return storyBuilders
        .map((storyBuilder) => _createStoryCard(storyBuilder, user))
        .toList();
  }

  Widget _createStoryCard(StoryBuilder storyBuilder, User user) {
    return Center(
      child: Card(
        elevation: 10.0,
        child: CreateMetaStoryView(
          story: storyBuilder,
          onSave: (StoryBuilder newStory) {
            setState(() {
              _goToEditStoryView(newStory);
            });
          },
          onDelete: (StoryBuilder story) async {
            await _deleteStory(user, story);
            setState(() {
              _storyBuilderCatalogMemo = AsyncMemoizer();
            });
          },
        ),
      ),
    );
  }

  _goToEditStoryView(StoryBuilder story) {
    Navigator.pushNamed(context, ExtractEditStoryViewArguments.routeName,
        arguments: EditStoryViewArguments(story: story, locale: widget.locale));
  }

  _deleteStory(User user, StoryBuilder story) async {
    return await StoryPersistence.instance.deleteStory(user, story);
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
          child: optionBox(context, LDLocalizations.of(context).edit),
          onPress: onEdit,
        ),
      ],
    );
  }
}

class CreateMetaStoryView extends StatefulWidget {
  final Function(StoryBuilder story) onSave;
  final StoryBuilder story;
  final Function(StoryBuilder story) onDelete;

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
            initialValue: widget.story == null ? "" : widget.story.authors[0],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                child: Text(LDLocalizations.of(context).edit),
              ),
            ),
            if (widget.onDelete != null)
              Padding(
                padding: EdgeInsets.all(4.0),
                child: RaisedButton(
                  onPressed: () {
                    widget.onDelete(widget.story);
                  },
                  child: Text(LDLocalizations.of(context).remove),
                ),
              ),
          ]),
        ],
      ),
    );
  }
}
