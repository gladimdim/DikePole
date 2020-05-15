import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/creator/components/user_story_details_view.dart';
import 'package:locadeserta/creator/components/user_story_view.dart';
import 'package:locadeserta/import_gladstories_view.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/story_persistence.dart';

class UserStoriesList extends StatefulWidget {
  static const String routeName = "/user_stories_list";

  @override
  _UserStoriesListState createState() => _UserStoriesListState();
}

class _UserStoriesListState extends State<UserStoriesList> {
  Story story;
  List<Story> storyBuilders = [];

  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: LDLocalizations.ownStories,
      actions: [
        AppBarObject(
          text: LDLocalizations.backToMenu,
          onTap: () => Navigator.pop(context),
        )
      ],
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BorderedContainer(
              child: SlideableButton(
                onPress: () async {
                  await Navigator.pushNamed(
                      context, ImportGladStoryView.routeName);
                },
                child: FatContainer(
                  text: LDLocalizations.labelImport,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BorderedContainer(
              child: SlideableButton(
                onPress: () async {
                  try {
                    await Navigator.pushNamed(
                      context,
                      UserStoryDetailsView.routeName,
                      arguments: UserStoryDetailsViewArguments(
                        story: Story(
                            title: "Your title",
                            description: "Your description",
                            authors: "Your name"),
                      ),
                    );
                    setState(() {});
                  } catch (e) {
                    print(
                        "exception happened in navigating to UserStoryDetails: $e");
                  }
                },
                child: FatContainer(
                  text: LDLocalizations.createNewStory,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text(
              LDLocalizations.yourExistingStories,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Expanded(
            child: _buildStoryView(context),
          ),
        ],
      ),
    );
  }

  _buildStoryView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: _createStoryViews(
                StoryPersistence.instance.getCreatorStories(), context),
          ),
        ),
      ),
    );
  }

  List<Widget> _createStoryViews(List<Story> storyBuilders, context) {
    return storyBuilders
        .map((storyBuilder) => _createStoryView(storyBuilder))
        .toList();
  }

  Widget _createStoryView(Story story) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: BorderedContainer(
          child: UserStoryView(
            story: story,
          ),
        ),
      ),
    );
  }
}
