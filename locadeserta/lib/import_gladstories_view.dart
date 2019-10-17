import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/fat_button.dart';
import 'package:locadeserta/creator/story/persistence.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';

class ImportGladStoryView extends StatefulWidget {
  static final String routeName = "/import_glad_story";

  @override
  _ImportGladStoryViewState createState() => _ImportGladStoryViewState();
}

class _ImportGladStoryViewState extends State<ImportGladStoryView> {
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LDLocalizations.exportGladStoryToJson),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(LDLocalizations.pasteFullJSON),
            BorderedContainer(
              child: TextField(
                controller: _controller,
                maxLines: 15,
              ),
            ),
            SlideableButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FatButton(
                  text: LDLocalizations.labelImport,
                ),
              ),
              onPress: () async {
                var story = Story.fromJson(_controller.text);
                var user = await Auth().currentUser();
                await StoryPersistence.instance
                    .writeStory(user, story);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
