import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/dividers.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/server/server.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadPassedStoryView extends StatefulWidget {
  final Story story;

  UploadPassedStoryView({required this.story});

  @override
  _UploadPassedStoryViewState createState() => _UploadPassedStoryViewState();
}

class _UploadPassedStoryViewState extends State<UploadPassedStoryView> {
  bool uploaded = false;
  bool uploading = false;
  String? messageText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(LDLocalizations.labelInstructionsForUploadingStory),
        )),
        VDivider(),
        BorderedContainer(
          child: IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: () async {
              setState(() {
                uploading = true;
                messageText = "";
                uploaded = false;
              });
              var result;
              try {
                result = await uploadStoryToServer(widget.story);
                setState(() {
                  messageText = result;
                  uploading = false;
                  uploaded = true;
                });
              } catch (e) {
                setState(() {
                  uploaded = false;
                  uploading = false;
                  messageText = e.toString();
                });
              }
            },
          ),
        ),
        if (uploading)
          Center(
            child: Text(LDLocalizations.labelFileIsBeingUploaded),
          ),
        VDivider(),
        if (uploaded && messageText != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: BorderedContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(
                        getFullLink(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: getFullLink()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        VDivider(),
        if (uploaded && messageText != null)
          Column(
            children: [
              FatContainer(text: LDLocalizations.labelShareActions),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SlideableButton(
                    child: BorderedContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          LDLocalizations.labelOpenInBrowser,
                        ),
                      ),
                    ),
                    onPress: () async {
                      if (await canLaunch(getFullLink())) {
                        await launch(getFullLink());
                      }
                    },
                  ),
                  SlideableButton(
                    child: BorderedContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          LDLocalizations.labelShareToTwitter,
                        ),
                      ),
                    ),
                    onPress: () async {
                      if (await canLaunch(getLinkToTwitter())) {
                        await launch(getLinkToTwitter());
                      }
                    },
                  ),
                  SlideableButton(
                    child: BorderedContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          LDLocalizations.labelShareToFacebook,
                        ),
                      ),
                    ),
                    onPress: () async {
                      if (await canLaunch(getLinkToFacebook())) {
                        await launch(getLinkToFacebook());
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  getFullLink() {
    return "https://dikepole.locadeserta.com/passed_stories/$messageText";
  }

  getLinkToTwitter() {
    return "http://twitter.com/share?text=Я закінчив читати інтерактивну історію ${widget.story.title}. Моя версія проходження знаходиться по посиланню &url=${getFullLink()}&hashtags=locadeserta,дикеполе";
  }

  getLinkToFacebook() {
    return "https://www.facebook.com/sharer/sharer.php?u=#${getFullLink()}&t=${widget.story.title}";
  }
}
