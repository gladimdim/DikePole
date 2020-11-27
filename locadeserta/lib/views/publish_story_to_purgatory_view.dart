import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/server/server.dart';

class PublishStoryToPurgatoryView extends StatefulWidget {
  final Story story;

  PublishStoryToPurgatoryView({this.story});

  @override
  _PublishStoryToPurgatoryViewState createState() =>
      _PublishStoryToPurgatoryViewState();
}

class _PublishStoryToPurgatoryViewState
    extends State<PublishStoryToPurgatoryView> {
  bool uploaded = false;
  bool uploading = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 9, child: FatContainer(text: getMainText())),
        Expanded(
          flex: 1,
          child: SlideableButton(
            onPress: () {
              uploadStoryToPurgatory();
            },
            child: BorderedContainer(
              child: FatContainer(text: LDLocalizations.publishUserStory),
            ),
          ),
        ),
      ],
    );
  }

  String getMainText() {
    if (uploading) {
      return LDLocalizations.labelUploading;
    }
    if (uploaded) {
      return LDLocalizations.labelUploadedPurgatoryStoryInstructions;
    }

    return LDLocalizations.labelInstructionsForUploadingStoryToPurgatory;
  }

  void uploadStoryToPurgatory() async {
    setState(() {
      uploading = true;
      uploaded = false;
    });
    var result = await uploadStoryToPurgatoryCatalog(widget.story);
    setState(() {
      uploaded = result;
      uploading = false;
    });
  }
}
