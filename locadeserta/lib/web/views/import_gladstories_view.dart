import 'package:flutter/material.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/creator/story/persistence.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/models/background_image.dart';
import 'package:locadeserta/InheritedAuth.dart';

class ImportGladStoryView extends StatefulWidget {
  static const String routeName = "/import_glad_story";

  @override
  _ImportGladStoryViewState createState() => _ImportGladStoryViewState();
}

class _ImportGladStoryViewState extends State<ImportGladStoryView> {
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: LDLocalizations.exportGladStoryToJson,
      actions: [
        AppBarObject(
            text: LDLocalizations.labelBack,
            onTap: () {
              Navigator.pop(context);
            })
      ],
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
                child: FatContainer(
                  text: LDLocalizations.labelImport,
                ),
              ),
              onPress: () async {
                var story = Story.fromJson(_controller.text,
                    imageResolver: BackgroundImage.getRandomImageForType);
                var user = InheritedAuth.of(context).auth.user;
                await StoryPersistence.instance.writeStory(user, story);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
