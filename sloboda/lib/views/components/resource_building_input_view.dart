import 'package:flutter/widgets.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/views/resource_view.dart';
import 'package:sloboda/extensions/list.dart';

class ResourceBuildingInputView extends StatelessWidget {
  const ResourceBuildingInputView({
    Key key,
    @required this.building,
  }) : super(key: key);

  final ResourceBuilding building;

  @override
  Widget build(BuildContext context) {
    var multiplier = building.amountOfWorkers() == 0 ? 1 : building.amountOfWorkers();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Input'),
        Column(
            children: building.requires.entries
                .toList()
                .divideBy(2)
                .map((row) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row
                      .map((e) => Row(
                    children: <Widget>[
                      ResourceImageView(
                        type: e.key,
                      ),
                      Text('x ${e.value * multiplier * building.workMultiplier}'),
                    ],
                  ))
                      .toList());
            }).toList())
      ],
    );
  }
}
