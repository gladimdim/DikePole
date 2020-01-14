import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class ResourceBuildingMetaView extends StatefulWidget {
  final RESOURCE_BUILDING_TYPES type;

  ResourceBuildingMetaView({this.type});

  @override
  _ResourceBuildingMetaViewState createState() =>
      _ResourceBuildingMetaViewState();
}

class _ResourceBuildingMetaViewState extends State<ResourceBuildingMetaView> {
  @override
  Widget build(BuildContext context) {
    var building = ResourceBuilding.fromType(widget.type);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${buildingTypeToString(widget.type)}',
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                buildingTypeToIconPath(widget.type),
                height: 64,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 5,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Build'),
            ...building.requiredToBuild.entries.map((e) {
              return Row(
                children: [
                  Image.asset(
                    resourceTypesToImagePath(e.key),
                    height: 64,
                  ),
                  Text('${e.value}'),
                ],
              );
            }).toList()
          ],
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Max'),
            Row(children: [
              Text('${building.maxWorkers}x'),
              Icon(Icons.person),
            ]),
          ],
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Output'),
            Text(
                '${resourceTypesToString(building.produces)}: ${building.workMultiplier}'),
          ],
        )
      ],
    );
  }
}
