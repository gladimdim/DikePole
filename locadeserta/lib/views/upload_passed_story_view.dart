import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/server/server.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadPassedStoryView extends StatefulWidget {
  final Story story;

  UploadPassedStoryView({this.story});

  @override
  _UploadPassedStoryViewState createState() => _UploadPassedStoryViewState();
}

class _UploadPassedStoryViewState extends State<UploadPassedStoryView> {
  bool uploaded = false;
  bool uploading = false;
  String messageText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Text(LDLocalizations.labelInstructionsForUploadingStory)),
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
        if (uploaded && messageText != null)
          Wrap(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    LDLocalizations.labelOpenInBrowser,
                  ),
                ),
                onTap: () async {
                  if (await canLaunch(getFullLink())) {
                    await launch(getFullLink());
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: getFullLink()),
                  );
                },
              )
            ],
          ),
      ],
    );
  }

  getFullLink() {
    return "https://dikepole.locadeserta.com/passed_stories/$messageText";
  }
}
