import 'package:flutter/widgets.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/models/catalogs.dart';

class HistoryWheel extends StatelessWidget {
  final CatalogStory catalogStory;

  HistoryWheel({this.catalogStory});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BorderedContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(this.catalogStory.title),
            Text(this.catalogStory.year),
          ],
        ),
      ),
    );
  }
}
