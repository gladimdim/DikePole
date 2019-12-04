import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart' as StoryModel;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'story_history.dart';
import 'package:image/image.dart' as ImageUI;
import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

class PdfCreator {
  final StoryHistory story;
  var _images = Map<String, ImageUI.Image>();
  StreamController<Tuple2<double, String>> _decodeProgress;
  Stream decodeProgress;

  PdfCreator({this.story}) {
    _decodeProgress = StreamController<Tuple2<double, String>>();
    decodeProgress = _decodeProgress.stream;
  }

  loadImages() async {
    var imageItems = this
        .story
        .getHistory()
        .where((historyItem) => historyItem.type == PassageTypes.IMAGE);
    var counter = 0.0;
    var futuresCompleted = await Future.forEach(imageItems, ((imageItem) async {
      if (_images.containsKey(imageItem.value[1])) {
        return;
      }
      var file = await rootBundle.load(imageItem.value[1]);
      counter += 0.3;
      print("decoding image: ${imageItem.value[1]}");
      _decodeProgress.sink.add(Tuple2(counter, imageItem.value[1]));
      var uiImage = await compute(decodeImage, file.buffer.asUint8List());
      _images[imageItem.value[1]] = uiImage;
    }));

    return futuresCompleted;
  }

  Widget toPdfWidget(Font ttf, Document pdf) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: story
            .getHistory()
            .map((historyItem) => historyToPdf(historyItem, ttf, pdf))
            .toList());
  }

  Future<Document> toPdfDocument(String title, String author) async {
    ByteData font = await rootBundle.load("fonts/Raleway/Raleway-Bold.ttf");
    final ttf = Font.ttf(font.buffer.asByteData());
    final pdf = Document();
    pdf.addPage(
      Page(
          pageFormat: PdfPageFormat.a4,
          build: (Context context) {
            return Container(
              decoration: BoxDecoration(
                border: BoxBorder(
                  width: 2.0,
                  left: true,
                  right: true,
                  bottom: true,
                  top: true,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Title: ",
                        style: TextStyle(
                            font: ttf,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        title,
                        style: TextStyle(font: ttf, fontSize: 30),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Authors: ",
                        style: TextStyle(
                            font: ttf,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        author,
                        style: TextStyle(font: ttf, fontSize: 30),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );

    var child = toPdfWidget(ttf, pdf);
    var amountOfImages = _images.length;
    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat(
            21.0 * PdfPageFormat.cm,
            (story.getHistory().length / 2 * 29.7 + amountOfImages * 10.0) *
                PdfPageFormat.cm,
            marginAll: 2.0 * PdfPageFormat.cm),
        build: (Context context) {
          return child;
        },
      ),
    );

    return pdf;
  }

  Widget historyToPdf(HistoryItemBase historyItem, Font ttf, Document pdf) {
    switch (historyItem.type) {
      case PassageTypes.TEXT:
        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: BoxBorder(
              width: 2.0,
              left: true,
              right: true,
              bottom: true,
              top: true,
            ),
          ),
          child: Center(
            child: _trueTypeText(historyItem.value, ttf),
          ),
        );
      case PassageTypes.IMAGE:
        var img = _images[historyItem.value[1]];

        final image = PdfImage(
          pdf.document,
          image: img.data.buffer.asUint8List(),
          width: img.width,
          height: img.height,
        );

        var result = Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: BoxBorder(
              width: 2.0,
              left: true,
              right: true,
              bottom: true,
              top: true,
            ),
          ),
          child: Image(
            image,
          ),
        );

        return result;
      default:
        throw 'Unsupported type: ${historyItem.type}';
    }
  }

  Widget _trueTypeText(String text, Font ttf) {
    return Text(
      text,
      style: TextStyle(font: ttf, fontSize: 18),
    );
  }

  dispose() {
    _decodeProgress.close();
  }
}

ImageUI.Image decodeImage(List<int> input) {
  print("yes");
  return ImageUI.decodeImage(input);
}

class PdfGladStoriesCreator {
  final StoryModel.Story story;
  var _images = Map<String, ImageUI.Image>();
  StreamController<Tuple2<double, String>> _decodeProgress;
  Stream decodeProgress;

  PdfGladStoriesCreator({this.story}) {
    _decodeProgress = StreamController<Tuple2<double, String>>();
    decodeProgress = _decodeProgress.stream;
  }

  loadImages() async {
    var imageItems = this
        .story
        .history
        .where((historyItem) => historyItem.imagePath != null);
    var counter = 0.0;
    var futuresCompleted = await Future.forEach(imageItems, ((imageItem) async {
      if (_images.containsKey(imageItem.imagePath[1])) {
        return;
      }
      var file = await rootBundle.load(imageItem.imagePath[1]);
      counter += 0.3;
      print("decoding image: ${imageItem.imagePath[1]}");
      _decodeProgress.sink.add(Tuple2(counter, imageItem.imagePath[1]));
      var uiImage = await compute(decodeImage, file.buffer.asUint8List());
      _images[imageItem.imagePath[1]] = uiImage;
    }));

    return futuresCompleted;
  }

  Widget toPdfWidget(Font ttf, Document pdf) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: story.history
            .map((historyItem) => historyToPdf(historyItem, ttf, pdf))
            .toList());
  }

  Future<Document> toPdfDocument(String title, String author) async {
    ByteData font = await rootBundle.load("fonts/Raleway/Raleway-Bold.ttf");
    final ttf = Font.ttf(font.buffer.asByteData());
    final pdf = Document();
    pdf.addPage(
      Page(
          pageFormat: PdfPageFormat.a4,
          build: (Context context) {
            return Container(
              decoration: BoxDecoration(
                border: BoxBorder(
                  width: 2.0,
                  left: true,
                  right: true,
                  bottom: true,
                  top: true,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Title: ",
                        style: TextStyle(
                            font: ttf,
                            fontSize: 48,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        title,
                        style: TextStyle(font: ttf, fontSize: 30),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Authors: ",
                        style: TextStyle(
                            font: ttf,
                            fontSize: 38,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        author,
                        style: TextStyle(font: ttf, fontSize: 28),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
    var child = toPdfWidget(ttf, pdf);
    var amountOfImages = _images.length;
    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat(
            21.0 * PdfPageFormat.cm,
            (story.history.length / 2 * 29.7 + amountOfImages * 10.0) *
                PdfPageFormat.cm,
            marginAll: 2.0 * PdfPageFormat.cm),
        build: (Context context) {
          return child;
        },
      ),
    );

    return pdf;
  }

  Widget historyToPdf(
      StoryModel.HistoryItem historyItem, Font ttf, Document pdf) {
    var imageContainer;
    if (historyItem.imagePath != null) {
      var img = _images[historyItem.imagePath[1]];

      final image = PdfImage(
        pdf.document,
        image: img.data.buffer.asUint8List(),
        width: img.width,
        height: img.height,
      );

      imageContainer = Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: BoxBorder(
            width: 2.0,
            left: true,
            right: true,
            bottom: true,
            top: true,
          ),
        ),
        child: Image(
          image,
        ),
      );
    }
    return Column(
      children: [
        if (historyItem.imagePath != null) imageContainer,
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: BoxBorder(
              width: 2.0,
              left: true,
              right: true,
              bottom: true,
              top: true,
            ),
          ),
          child: Center(
            child: _trueTypeText(historyItem.text, ttf),
          ),
        ),
      ],
    );
  }

  Widget _trueTypeText(String text, Font ttf) {
    return Text(
      text,
      style: TextStyle(font: ttf, fontSize: 18),
    );
  }

  dispose() {
    _decodeProgress.close();
  }
}
