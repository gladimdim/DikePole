import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/creator/story/persistence.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';

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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          LDLocalizations.exportGladStoryToJson,
          style: Theme.of(context).textTheme.title,
        ),
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: BorderedContainer(
                child: SlideableButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FatContainer(
                      text: LDLocalizations.labelImport,
                    ),
                  ),
                  onPress: () async {
                    var story = Story.fromJson(_controller.text,
                        imageResolver: BackgroundImage.getRandomImageForType);
                    var user = await Auth().currentUser();
                    await StoryPersistence.instance.writeStory(user, story);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
