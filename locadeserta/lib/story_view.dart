import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:toast/toast.dart';

import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/pdf_creator.dart';
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
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32),
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
                            await Persistence.instance
                                .saveStateToStorageForUser(widget.user,
                                    widget.catalogStory, storyBridge);
                          })
                      : Center(child: CircularProgressIndicator()),
                ),
                AppBarCustom(
                  title: widget.catalogStory.title,
                  appBarButtons: [
                    AppBarObject(
                      onTap: () => Navigator.pop(context),
                      text: LDLocalizations.of(context).backToStories,
                    ),
                    AppBarObject(
                      onTap: _resetStory,
                      text: LDLocalizations.of(context).reset,
                    ),
                    AppBarObject(
                      onTap: () => _onExportPressed(context),
                      text: LDLocalizations.of(context).shareStory,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _resetStory() async {
    await storyBridge.resetState();
  }

  _onExportPressed(BuildContext context) async {
    final creator = PdfCreator(story: currentStory.storyHistory);

    Toast.show(LDLocalizations.of(context).preparingExport, context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

    final pdf = await creator.toPdfDocument(widget.catalogStory.title, widget.catalogStory.author);

    Toast.show(LDLocalizations.of(context).openingShareDialog, context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

    await WcFlutterShare.share(
      sharePopupTitle: LDLocalizations.of(context).shareStory,
      fileName: '${widget.catalogStory.title}.pdf',
      mimeType: 'application/pdf',
      bytesOfFile: pdf.save(),
    );
  }
}
