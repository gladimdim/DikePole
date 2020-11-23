import 'package:flutter/material.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/server/server.dart';

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
        Center(
            child: Text(
                "Press upload button to generate unique url that you can share")),
        BorderedContainer(
          child: IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: () async {
              setState(() {
                uploading = true;
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
            child: Text("File is being uploaded"),
          ),
        if (messageText != null)
          Center(
            child: Text(messageText),
          ),
      ],
    );
  }
}
