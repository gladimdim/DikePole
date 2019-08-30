import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/story_history.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/passage_view.dart';
import 'package:locadeserta/models/persistence.dart';
import 'package:locadeserta/models/story_bridge.dart';
import 'package:path_provider/path_provider.dart';

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
  GlobalKey _globalKey = new GlobalKey();

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
                  child: RepaintBoundary(
                    key: _globalKey,
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
                      onTap: () async {
                        try {
                          RenderRepaintBoundary boundary =
                              _globalKey.currentContext.findRenderObject();
                          ui.Image image =
                              await boundary.toImage(pixelRatio: 3.0);
                          ByteData byteData = await image.toByteData(
                              format: ui.ImageByteFormat.png);
                          var pngBytes = byteData.buffer.asUint8List();
                          _writeScreenshot(pngBytes);
                          print("DONE");
                        } catch (e) {
                          print(e);
                        }
                      },
                      text: LDLocalizations.of(context).shareStory,
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/screen1.png');
  }

  Future _writeScreenshot(Uint8List base64) async {
    final file = await _localFile;

    // Write the file.
    return await file.writeAsBytes(base64);
  }




  _resetStory() async {
    await storyBridge.resetState();
  }
}
