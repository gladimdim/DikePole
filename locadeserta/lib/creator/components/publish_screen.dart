import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:share_extend/share_extend.dart';

class PublishUserStory extends StatefulWidget {
  static const routeName = "/publish_story";
  final Story story;

  PublishUserStory({this.story});

  @override
  _PublishUserStoryState createState() => _PublishUserStoryState();
}

class _PublishUserStoryState extends State<PublishUserStory> {
  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: LDLocalizations.publishUserStory,
      actions: [
        AppBarObject(
          text: LDLocalizations.backToStories,
          onTap: () => Navigator.pop(context),
        )
      ],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(LDLocalizations.publishStoryInstructions),
          ),
          BorderedContainer(
            child: SlideableButton(
              child: FatContainer(text: LDLocalizations.shareStory),
              onPress: () {
                var json = widget.story.toJson();
                ShareExtend.share(json, "text");
              },
            ),
          )
        ],
      ),
    );
  }
}

class PublishStoryViewArguments {
  final Story story;

  PublishStoryViewArguments({this.story});
}

class ExtractPlublishStoryViewArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final PublishStoryViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return PublishUserStory(
      story: args.story,
    );
  }
}
