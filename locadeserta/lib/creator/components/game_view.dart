import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/story_view.dart';
import 'package:locadeserta/export_pdf_view.dart';
import 'package:locadeserta/loaders/catalogs.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/story_persistence.dart';
import 'package:locadeserta/views/export_to_markdown_view.dart';

class GameView extends StatefulWidget {
  final Story story;
  final CatalogStory catalogStory;

  GameView({this.story, this.catalogStory});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) {
    final title = widget.catalogStory != null
        ? widget.catalogStory.title
        : LDLocalizations.previewStory;
    return NarrowScaffold(
      title: title,
      actions: [
        AppBarObject(
          onTap: () => Navigator.pop(context),
          text: LDLocalizations.backToStories,
        ),
        AppBarObject(
          onTap: () async {
            if (widget.catalogStory != null) {
              var templateStory = await StoryPersistence.instance
                  .readyStoryByCatalog(context, widget.catalogStory);
              widget.story.root = templateStory.root;
            }
            widget.story.reset();

            setState(() {});
          },
          text: LDLocalizations.reset,
        ),
        AppBarObject(
          onTap: () {
            Navigator.pushNamed(
              context,
              ExtractExportGladStoriesPdfViewArguments.routeName,
              arguments: ExportGladStoriesPdfViewArguments(
                story: widget.story,
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
                    title: "Markdown export",
                    actions: [
                      AppBarObject(
                        onTap: () => Navigator.pop(context),
                        text: LDLocalizations.labelBack,
                      ),
                    ],
                    body: ExportToMarkDownView(story: widget.story)),
              ),
            );
          },
          text: LDLocalizations.labelConvertToMarkdown,
        )
      ],
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: StoryView(
          currentStory: widget.story,
          previewMode: widget.catalogStory == null,
        ),
      ),
    );
  }
}

class GameViewArguments {
  final Story story;

  GameViewArguments({this.story});
}

class ExtractArgumentsGameView extends StatelessWidget {
  static const routeName = "/play";

  Widget build(BuildContext context) {
    final GameViewArguments args = ModalRoute.of(context).settings.arguments;

    return GameView(
      story: args.story,
    );
  }
}
