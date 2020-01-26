import 'package:flutter/widgets.dart';
import 'package:locadeserta/city_building/models/abstract/producable.dart';
import 'package:locadeserta/city_building/views/resource_view.dart';

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
        Text('Output'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ResourceImageView(
              type: building.produces,
            ),
            Text('x ${building.workMultiplier * multiplier}'),
          ],
        ),
      ],
    );
  }
}
