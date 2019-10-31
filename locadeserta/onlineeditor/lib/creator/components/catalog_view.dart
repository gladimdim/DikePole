import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/creator/components/meta_story_view.dart';
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
  List<Story> storyBuilders = [];
  AsyncMemoizer _storyBuilderCatalogMemo = AsyncMemoizer();

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: Card(
          elevation: 10.0,
          child: MetaStoryView(
            story: story,
            onSave: (Story newStory) async {
              await StoryPersistence.instance
                  .writeStory(InheritedAuth.of(context).auth.getUser(), story);
              setState(() {});
            },
            onEdit: (story) {
              _goToEditStoryView(story, context);
            },
            onDelete: (story) async {
              await _deleteStory(
                  InheritedAuth.of(context).auth.getUser(), story);
              _resetStoryBuilderFuture();
            },
          ),
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

  _deleteStory(LDUser user, Story story) async {
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
