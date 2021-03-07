import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/models/Localizations.dart';

class ExportToMarkDownView extends StatefulWidget {
  final Story story;

  ExportToMarkDownView({required this.story});
  @override
  _ExportToMarkDownViewState createState() => _ExportToMarkDownViewState();
}

class _ExportToMarkDownViewState extends State<ExportToMarkDownView> {
  bool showSource = false;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text =
        widget.story.toMarkdownString("https://locadeserta.com/game/assets");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: controller.text,
                    ),
                  );
                },
              ),
              SlideableButton(
                child: BorderedContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(showSource
                        ? LDLocalizations.labelShowMarkdownRendered
                        : LDLocalizations.labelShowMarkdownSource),
                  ),
                ),
                onPress: () {
                  setState(() {
                    showSource = !showSource;
                  });
                },
              ),
            ],
          ),
        ),
        if (showSource)
          Expanded(
            flex: 9,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 2000,
                  controller: controller,
                ),
              ),
            ),
          ),
        if (!showSource)
          Expanded(
            flex: 9,
            child: Markdown(
              data: controller.text,
            ),
          ),
      ],
    );
  }
}
