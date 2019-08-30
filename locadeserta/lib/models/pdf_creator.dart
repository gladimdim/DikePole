import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'story_history.dart';
import 'package:image/image.dart' as ImageUI;

class PdfCreator {
  final StoryHistory storyHistory;
  var _images = Map<String, ByteData>();

  PdfCreator({this.storyHistory}) {
    _loadImages();
  }

  _loadImages() async {
    var imageItems = this
        .storyHistory
        .getHistory()
        .where((historyItem) => historyItem.type == PassageTypes.IMAGE);
    imageItems.forEach((imageItem) async {
      var file = await rootBundle.load(imageItem.value[1]);
      _images[imageItem.value[1]] = file;
    });
  }

  Future<Widget> toPdfWidget(Font ttf, Document pdf) async {
    return Center(
      child: Column(
        children: storyHistory
            .getHistory()
            .map((historyItem) => historyToPdf(historyItem, ttf, pdf))
            .toList(),
      ),
    ); // Center
  }

  Future<Document> toPdfDocument() async {
    ByteData font = await rootBundle.load("fonts/Raleway/Raleway-Bold.ttf");
    final ttf = Font.ttf(font.buffer.asByteData());
    final pdf = Document();
    var child = await toPdfWidget(ttf, pdf);
    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat(21.0 * PdfPageFormat.cm,
            storyHistory.getHistory().length / 3 * 29.7 * PdfPageFormat.cm,
            marginAll: 2.0 * PdfPageFormat.cm),
        build: (Context context) {
          return child;
        },
      ),
    );

    return pdf;
  }

  Container historyToPdf(HistoryItemBase historyItem, Font ttf, Document pdf) {
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
          child: Text(
            historyItem.value,
            style: TextStyle(font: ttf, fontSize: 18),
          ),
        );
      case PassageTypes.IMAGE:
        var imageFile = _images[historyItem.value[1]];
        final img = ImageUI.decodeImage(imageFile.buffer.asUint8List());
        final image = PdfImage(
          pdf.document,
          image: img.data.buffer.asUint8List(),
          width: img.width,
          height: img.height,
        );
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
          child: Image(
            image,
          ),
        );
      default:
        throw 'Unsupported type: ${historyItem.type}';
    }
  }
}
