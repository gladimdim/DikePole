import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/story_persistence.dart';
import 'package:locadeserta/views/publish_story_to_purgatory_view.dart';
import 'package:locadeserta/views/story_edit_view.dart';
import 'package:locadeserta/views/story_json_export_view.dart';

class EditStoryView extends StatefulWidget {
  final Story story;
  static const routeName = "/editStories";

  EditStoryView({required this.story});

  @override
  _EditStoryViewState createState() => _EditStoryViewState();
}

class _EditStoryViewState extends State<EditStoryView> {
  @override
  Widget build(BuildContext context) {
    var story = widget.story;
    return NarrowScaffold(
      body: StoryEditView(story: widget.story),
      title: LDLocalizations.createStory,
      actions: [
        AppBarObject(
            text: LDLocalizations.backToStories,
            onTap: () {
              Navigator.pop(context);
            }),
        AppBarObject(
          text: LDLocalizations.save,
          onTap: () => _saveStoryCallback(context),
        ),
        AppBarObject(
          text: LDLocalizations.startStory,
          onTap: () async {
            story.reset();
            await Navigator.pushNamed(
              context,
              ExtractArgumentsGameView.routeName,
              arguments: GameViewArguments(story: story, previewMode: true),
            );
            story.reset();
          },
        ),
        AppBarObject(
          text: LDLocalizations.exportGladStoryToJson,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NarrowScaffold(
                    title: LDLocalizations.exportGladStoryToJson,
                    actions: [],
                    showBackButton: true,
                    body: StoryJsonExportView(story: widget.story)),
              ),
            );
          },
        ),
        AppBarObject(
          text: LDLocalizations.publishUserStory,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NarrowScaffold(
                    title: LDLocalizations.publishUserStory,
                    actions: [],
                    showBackButton: true,
                    body: PublishStoryToPurgatoryView(story: widget.story)),
              ),
            );
          },
        ),
      ],
    );
  }

  _saveStory(BuildContext context) async {
    await StoryPersistence.instance.writeCreatorStory(widget.story);
    setState(() {});
  }

  _saveStoryCallback(BuildContext context) {
    _saveStory(context);
  }
}

class EditStoryViewArguments {
  final Story story;

  EditStoryViewArguments({required this.story});
}

class ExtractEditStoryViewArguments extends StatelessWidget {
  static const routeName = "/edit_story";

  Widget build(BuildContext context) {
    final EditStoryViewArguments args =
        ModalRoute.of(context)?.settings.arguments as EditStoryViewArguments;

    return EditStoryView(
      story: args.story,
    );
  }
}
