import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:share/share.dart';

class ShareUserStoryToPdf extends StatefulWidget {
  static const routeName = "/publish_story";
  final Story story;

  ShareUserStoryToPdf({required this.story});

  @override
  _ShareUserStoryToPdfState createState() => _ShareUserStoryToPdfState();
}

class _ShareUserStoryToPdfState extends State<ShareUserStoryToPdf> {
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
                Share.share(json.toString());
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

  PublishStoryViewArguments({required this.story});
}

class ExtractPlublishStoryViewArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final PublishStoryViewArguments args =
        ModalRoute.of(context)!.settings.arguments as PublishStoryViewArguments;

    return ShareUserStoryToPdf(
      story: args.story,
    );
  }
}
