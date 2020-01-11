import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';
import 'package:locadeserta/components/bordered_container.dart';

class ResourceBuildingsPage extends StatefulWidget {
  final Sloboda city;

  ResourceBuildingsPage({this.city});

  @override
  _ResourceBuildingsPageState createState() => _ResourceBuildingsPageState();
}

class _ResourceBuildingsPageState extends State<ResourceBuildingsPage> {
  @override
  Widget build(BuildContext context) {
    var city = widget.city;
    var resourceFieldsColumn = city.resourceBuildings.map<Widget>((building) {
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
              setState(() {
                city.removeResourceBuilding(building);
              });
            },
          )
        ],
      );
    }).toList();
    resourceFieldsColumn.add(
      Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Add",
            style: Theme.of(context).textTheme.body1,
          )),
    );
    resourceFieldsColumn.addAll(
      RESOURCE_BUILDING_TYPES.values.map((value) {
        var building = ResourceBuilding.fromType(value);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BorderedContainer(
              child: SlideableButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('${buildingTypeToString(value)}'),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: building.requiredToBuild.entries.map((e) {
                        return Text('${resourceTypesToString(e.key)}: ${e.value}');
                      }).toList(),
                    ),
                  ],
                ),
                onPress: () {
                  setState(() {
                    city.resourceBuildings
                        .add(ResourceBuilding.fromType(value));
                  });
                },
              ),
            ),
          ),
        );
      }).toList(),
    );
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: resourceFieldsColumn);
  }
}
