import 'package:flutter/material.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';

class ResourceBuildingBuilt extends StatefulWidget {
  final ResourceBuilding building;
  final Function(ResourceBuilding building) onBuildingRemove;
  final Sloboda city;
  ResourceBuildingBuilt({this.building, this.onBuildingRemove, this.city});

  @override
  _ResourceBuildingBuiltState createState() => _ResourceBuildingBuiltState();
}

class _ResourceBuildingBuiltState extends State<ResourceBuildingBuilt> {
  @override
  Widget build(BuildContext context) {
    var city = widget.city;
    var building = widget.building;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: !building.isEmpty()
              ? () {
            setState(() {
              building.removeWorker();
            });
          }
              : null,
        ),
        Row(
          children: [
            Text(
              buildingTypeToString(building.type),
            ),
            Text(
                ': +${building.output()} ${resourceTypesToString(building.produces)}'),
            if (building.hasWorkers())
              Text('( ${building.amountOfWorkers()} '),
            if (building.hasWorkers()) Icon(Icons.person),
            if (building.hasWorkers()) Text(')'),
          ],
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: !building.isFull()
              ? () {
            setState(() {
              building.addWorker(city.getFirstFreeCitizen());
            });
          }
              : null,
        ),
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () {
            city.removeResourceBuilding(building);
          },
        )
      ],
    );
  }
}
