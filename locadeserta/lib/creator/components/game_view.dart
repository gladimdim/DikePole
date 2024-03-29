import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/edit_story.dart';
import 'package:locadeserta/creator/components/story_view.dart';
import 'package:locadeserta/loaders/catalogs.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/story_persistence.dart';
import 'package:locadeserta/views/export_to_markdown_view.dart';
import 'package:locadeserta/views/upload_passed_story_view.dart';

class GameView extends StatefulWidget {
  final Story story;
  final CatalogStory? catalogStory;
  final bool previewMode;

  GameView({required this.story, this.catalogStory, required this.previewMode});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: getTitle(),
      actions: [
        AppBarObject(
          onTap: () => Navigator.pop(context),
          text: LDLocalizations.backToStories,
        ),
        AppBarObject(
          onTap: () async {
            if (widget.catalogStory != null) {
              var templateStory = await StoryPersistence.instance
                  .readyStoryByCatalog(context, widget.catalogStory!);
              widget.story.root = templateStory.root;
            }
            widget.story.reset();

            setState(() {});
          },
          text: LDLocalizations.reset,
        ),
        // AppBarObject(
        //   onTap: () {
        //     Navigator.pushNamed(
        //       context,
        //       ExtractExportGladStoriesPdfViewArguments.routeName,
        //       arguments: ExportGladStoriesPdfViewArguments(
        //         story: widget.story,
        //       ),
        //     );
        //   },
        //   text: LDLocalizations.shareStoryToPdf,
        // ),
        AppBarObject(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NarrowScaffold(
                    title: LDLocalizations.shareStory,
                    actions: [],
                    showBackButton: true,
                    body: UploadPassedStoryView(story: widget.story)),
              ),
            );
          },
          text: LDLocalizations.shareStory,
        ),
        AppBarObject(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NarrowScaffold(
                    title: LDLocalizations.labelConvertToMarkdown,
                    actions: [],
                    body: ExportToMarkDownView(story: widget.story)),
              ),
            );
          },
          text: LDLocalizations.labelConvertToMarkdown,
        ),
        if (!widget.previewMode)
          AppBarObject(
            onTap: () async {
              var story = Story.fromJson(widget.story.toJson());
              story.title = story.title + " - 1";
              await Navigator.pushNamed(
                  context, ExtractEditStoryViewArguments.routeName,
                  arguments: EditStoryViewArguments(story: story));
            },
            text: LDLocalizations.labelEditStory,
          )
      ],
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: StoryView(
          currentStory: widget.story,
          previewMode: widget.previewMode,
        ),
      ),
    );
  }

  String getTitle() {
    var catalog = widget.catalogStory;
    if (catalog != null) {
      return catalog.title;
    } else {
      return LDLocalizations.previewStory;
    }
  }
}

class GameViewArguments {
  final Story story;
  final bool previewMode;
  GameViewArguments({required this.story, required this.previewMode});
}

class ExtractArgumentsGameView extends StatelessWidget {
  static const routeName = "/play";

  Widget build(BuildContext context) {
    final GameViewArguments args =
        ModalRoute.of(context)!.settings.arguments as GameViewArguments;

    return GameView(
      story: args.story,
      previewMode: args.previewMode,
    );
  }
}
