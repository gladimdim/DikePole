import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/InheritedAuth.dart';
import 'package:locadeserta/creator/components/edit_story.dart';

import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/creator/components/meta_story_view.dart';
import 'package:locadeserta/creator/story/persistence.dart';
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
  List<Story> storyBuilders = [];
  AsyncMemoizer _storyBuilderCatalogMemo = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    var user = InheritedAuth.of(context).auth.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LDLocalizations.createStory,
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
                await Navigator.pushNamed(
                    context, ImportGladStoryView.routeName);
                _resetStoryBuilderFuture();
              },
              child: FatContainer(
                text: LDLocalizations.labelImport,
              ),
            ),
            Expanded(
              child: _buildStoryView(context, user),
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
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Card(
                elevation: 10.0,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.book),
                      title: Text(LDLocalizations.createStory),
                    ),
                    EditMetaStoryView(
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
                    storyBuilders = snapshot.data;
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

  List<Widget> _createStoryCards(
      List<Story> storyBuilders, User user, context) {
    return storyBuilders
        .map((storyBuilder) => _createStoryCard(storyBuilder, user, context))
        .toList();
  }

  Widget _createStoryCard(Story story, User user, context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: Card(
          elevation: 10.0,
          child: MetaStoryView(
            story: story,
            onSave: (Story newStory) async {
              await StoryPersistence.instance.writeStory(user, story);
              setState(() {});
            },
            onEdit: (story) {
              _goToEditStoryView(story, context);
            },
            onDelete: (story) async {
              await _deleteStory(user, story);
              _resetStoryBuilderFuture();
            },
          ),
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
