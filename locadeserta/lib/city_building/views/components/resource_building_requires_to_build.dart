import 'package:flutter/widgets.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/views/resource_view.dart';
import 'package:locadeserta/extensions/list.dart';

class ResourceBuildingRequiresToBuildView extends StatelessWidget {
  const ResourceBuildingRequiresToBuildView({
    Key key,
    @required this.building,
  }) : super(key: key);

  final ResourceBuilding building;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Requires to build'),
        Column(
            children: building.requiredToBuild.entries
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
                      Text('x ${e.value}'),
                    ],
                  ))
                      .toList());
            }).toList())
      ],
    );
  }
}