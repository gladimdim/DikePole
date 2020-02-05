import 'package:flutter/widgets.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/resource_view.dart';

class ResourceBuildingOutputView extends StatelessWidget {
  const ResourceBuildingOutputView({
    Key key,
    @required this.building,
  }) : super(key: key);

  final Producable building;

  @override
  Widget build(BuildContext context) {
    var multiplier = building.amountOfWorkers() == 0 ? 1 : building.amountOfWorkers();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(SlobodaLocalizations.output),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ResourceImageView(
              type: building.produces,
            ),
            Text(' ${building.workMultiplier * multiplier}'),
          ],
        ),
      ],
    );
  }
}
