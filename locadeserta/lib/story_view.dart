import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/components/constants.dart';
import 'package:locadeserta/components/game_app_bar.dart';
import 'package:locadeserta/components/game_component.dart';
import 'package:locadeserta/export_pdf_view.dart';

import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/story_history.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/passage_view.dart';
import 'package:locadeserta/models/persistence.dart';
import 'package:locadeserta/models/story_bridge.dart';

class StoryView extends StatefulWidget {
  final CatalogStory catalogStory;
  final User user;

  StoryView({@required this.user, @required this.catalogStory});

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  StoryBridge storyBridge;
  List _previousPassages = List();

  @override
  void initState() {
    _initStoryBridge();
    super.initState();
  }

  Future<StoryBridge> _initStoryBridge() async {
    if (storyBridge == null) {
      storyBridge = StoryBridge();
      String stateJson;
      String historyJson;
      try {
        stateJson = await Persistence.instance
            .getStateJsonForUserAndCatalog(widget.user, widget.catalogStory);
        historyJson = await Persistence.instance
            .getHistoryJsonForUserAndCatalog(widget.user, widget.catalogStory);
      } catch (e) {
        print(e.toString());
      }

      await storyBridge.initStory(
          storyJson: widget.catalogStory.inkJson,
          state: stateJson,
          historyJson: historyJson);
    }
    return storyBridge;
  }

  Story currentStory;
  static const platform = const MethodChannel('gladimdim.locadeserta/Ink');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: storyBridge.streamStory.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Failed to load assets: ${snapshot.error}");
        }
        currentStory = storyBridge.story;
        return GameViewScaffold(
          child: Padding(
            padding: const EdgeInsets.only(top: APP_BAR_HEIGHT),
            child: snapshot.hasData
                ? Passage(
                    currentStory: currentStory,
                    onNextOptionSelected: (s, i) async {
                      _previousPassages.add(s);
                      switch (s.type) {
                        case PassageTypes.TEXT:
                          await storyBridge.doContinue();
                          break;
                        case PassageTypes.IMAGE:
                          await storyBridge.chooseChoiceIndex(i, s);
                          break;
                      }
                      await Persistence.instance.saveStateToStorageForUser(
                          widget.user, widget.catalogStory, storyBridge);
                    })
                : Center(child: CircularProgressIndicator()),
          ),
          appBar: GameAppBar(
            title: widget.catalogStory.title,
            onResetStory: _resetStory,
            onExportStory: () {
              Navigator.pushNamed(
                context,
                ExtractExportPdfViewArguments.routeName,
                arguments: ExportPdfViewArguments(
                  catalogStory: widget.catalogStory,
                  storyHistory: currentStory.storyHistory,
                ),
              );
            },
          ),
        );
      },
    );
  }

  _resetStory() async {
    await storyBridge.resetState();
  }
}
