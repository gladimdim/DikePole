import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/creator/components/text_editor.dart';

class StoryJsonExportView extends StatefulWidget {
  final Story story;

  StoryJsonExportView({required this.story});

  @override
  _StoryJsonExportViewState createState() => _StoryJsonExportViewState();
}

class _StoryJsonExportViewState extends State<StoryJsonExportView> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = jsonEncode(widget.story.toJson());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 9,
            child: TextEditor(
              text: controller.text,
              maxLines: 1000,
              controller: controller,
              onSave: (s) {},
              onSubmitted: (s) {},
            )),
        Expanded(
            child: IconButton(
          icon: Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(
              ClipboardData(
                text: controller.text,
              ),
            );
          },
        ))
      ],
    );
  }
}
