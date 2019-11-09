import 'package:flutter/material.dart';
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/animations/slideable_button.dart';
import 'package:onlineeditor/components/app_bar_custom.dart';
import 'package:onlineeditor/components/bordered_container.dart';
import 'package:onlineeditor/components/narrow_scaffold.dart';
import 'package:onlineeditor/creator/components/fat_container.dart';
import 'package:onlineeditor/creator/story/persistence.dart';
import 'package:onlineeditor/creator/story/story.dart';
import 'package:onlineeditor/views/inherited_auth.dart';

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
                var story = Story.fromJson(_controller.text);
                var user = InheritedAuth.of(context).auth.getUser();
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
