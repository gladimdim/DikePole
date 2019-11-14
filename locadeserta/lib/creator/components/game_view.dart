import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/components/game_app_bar.dart';
import 'package:locadeserta/components/game_component.dart';
import 'package:locadeserta/creator/components/story_view.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/export_pdf_view.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/catalogs.dart';

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
    return GameViewScaffold(
      appBar: GameAppBar(
        title: LDLocalizations.previewStory,
        onResetStory: () {
          setState(() {
            if (widget.catalogStory != null && widget.catalogStory.gladJson != null) {
              var templateStory = Story.fromJson(widget.catalogStory.gladJson);
              widget.story.root = templateStory.root;
            }
            widget.story.reset();
          });
        },
        onExportStory: () {
          Navigator.pushNamed(
            context,
            ExtractExportGladStoriesPdfViewArguments.routeName,
            arguments: ExportGladStoriesPdfViewArguments(
              story: widget.story,
            ),
          );
        },
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: StoryView(currentStory: widget.story),
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
