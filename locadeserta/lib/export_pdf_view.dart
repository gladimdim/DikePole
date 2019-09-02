import 'dart:io';

import 'package:flutter/material.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/models/pdf_creator.dart';
import 'package:locadeserta/models/story_history.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class ExportToPDF extends StatefulWidget {
  final StoryHistory storyHistory;
  final CatalogStory catalogStory;

  ExportToPDF({this.catalogStory, this.storyHistory});
  @override
  _ExportToPDFState createState() => _ExportToPDFState();
}

class _ExportToPDFState extends State<ExportToPDF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Export"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Export"),
          onPressed: () => _onExportPressed(context),
        )
      ),
    );
  }

  _onExportPressed(BuildContext context) async {
    final creator = PdfCreator(story: widget.storyHistory);
    print("creator start async");
    await creator.loadImages();
    print('creator end async"');
    print("before topdfdocument");
    final pdf = await creator.toPdfDocument(
        widget.catalogStory.title, widget.catalogStory.author);
    print("after topdfdocument");

    final file = await _localFile;
    await file.writeAsBytes(pdf.save());
    ShareExtend.share(file.path, "pdf");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/story.pdf');
  }
}


class ExportPdfViewArguments {
  final StoryHistory storyHistory;
  final CatalogStory catalogStory;

  ExportPdfViewArguments({this.catalogStory, this.storyHistory});
}

class ExtractExportPdfViewArguments extends StatelessWidget {
  static const routeName = "/exportToPdf";

  Widget build(BuildContext context) {
    final ExportPdfViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return ExportToPDF(
      storyHistory: args.storyHistory,
      catalogStory: args.catalogStory,
    );
  }
}
