import 'dart:io';

import 'package:flutter/material.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/models/pdf_creator.dart';
import 'package:locadeserta/models/story_history.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:tuple/tuple.dart';

class ExportToPDF extends StatefulWidget {
  final StoryHistory storyHistory;
  final CatalogStory catalogStory;
  PdfCreator creator;

  ExportToPDF({this.catalogStory, this.storyHistory}) {
    creator = PdfCreator(story: storyHistory);
  }

  @override
  _ExportToPDFState createState() => _ExportToPDFState();
}

class _ExportToPDFState extends State<ExportToPDF> {
  bool savingToFile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LDLocalizations.shareStory),
      ),
      body: Center(
        child: savingToFile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.import_export,
                    size: 150,
                  ),
                  Text(
                    LDLocalizations.savingExportFile,
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  )
                ],
              )
            : StreamBuilder<Tuple2<double, String>>(
                stream: widget.creator.decodeProgress,
                builder: (context, snapshot) {
                  print(snapshot.hasData);
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              LDLocalizations.processingImage,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30.0),
                            ),
                            Image(
                              image: AssetImage(snapshot.data.item2),
                            ),
                            LinearProgressIndicator(
                              value: snapshot.data.item1,
                              semanticsValue: snapshot.data.item1.toString(),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            LDLocalizations.longProcessDescription,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 150,
                          ),
                          RaisedButton(
                            child: Text(LDLocalizations.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            onPressed: () => _onExportPressed(context),
                          ),
                        ],
                      ),
                    );
                  }
                }),
      ),
    );
  }

  _onExportPressed(BuildContext context) async {
    setState(() {
      savingToFile = false;
    });
    final creator = widget.creator;
    await creator.loadImages();
    final pdf = await creator.toPdfDocument(
        widget.catalogStory.title, widget.catalogStory.author);
    final file = await _localFile;
    setState(() {
      savingToFile = true;
    });
    await file.writeAsBytes(pdf.save());
    ShareExtend.share(file.path, "pdf");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    var fileName = await _localPath;
    return File('$fileName/story.pdf');
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

/// CUSTOM ENGINE

class ExportGladStoriesPdfViewArguments {
  final Story story;

  ExportGladStoriesPdfViewArguments({this.story});
}

class ExtractExportGladStoriesPdfViewArguments extends StatelessWidget {
  static const routeName = "/exportGladStoriesToPdf";

  Widget build(BuildContext context) {
    final ExportGladStoriesPdfViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return ExportGladStoriesToPDF(
      story: args.story,
    );
  }
}

class ExportGladStoriesToPDF extends StatefulWidget {
  final Story story;
  PdfGladStoriesCreator creator;

  ExportGladStoriesToPDF({this.story}) {
    creator = PdfGladStoriesCreator(story: story);
  }

  @override
  _ExportGladStoriesToPDFState createState() => _ExportGladStoriesToPDFState();
}

class _ExportGladStoriesToPDFState extends State<ExportGladStoriesToPDF> {
  bool savingToFile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LDLocalizations.shareStory),
      ),
      body: Center(
        child: savingToFile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.import_export,
                    size: 150,
                  ),
                  Text(
                    LDLocalizations.savingExportFile,
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  )
                ],
              )
            : StreamBuilder<Tuple2<double, String>>(
                stream: widget.creator.decodeProgress,
                builder: (context, snapshot) {
                  print(snapshot.hasData);
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              LDLocalizations.processingImage,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30.0),
                            ),
                            Image(
                              image: AssetImage(snapshot.data.item2),
                            ),
                            LinearProgressIndicator(
                              value: snapshot.data.item1,
                              semanticsValue: snapshot.data.item1.toString(),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            LDLocalizations.longProcessDescription,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 150,
                          ),
                          RaisedButton(
                            child: Text(LDLocalizations.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            onPressed: () => _onExportPressed(context),
                          ),
                        ],
                      ),
                    );
                  }
                }),
      ),
    );
  }

  _onExportPressed(BuildContext context) async {
    setState(() {
      savingToFile = false;
    });
    final creator = widget.creator;
    await creator.loadImages();
    final pdf = await creator.toPdfDocument(
        widget.story.title, widget.story.authors);
    final file = await _localFile;
    setState(() {
      savingToFile = true;
    });
    await file.writeAsBytes(pdf.save());
    ShareExtend.share(file.path, "pdf");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    var fileName = await _localPath;
    return File('$fileName/story.pdf');
  }
}
