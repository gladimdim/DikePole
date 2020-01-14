import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';
import 'package:locadeserta/city_building/views/resource_buildings/resource_building_meta.dart';
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
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...city.resourceBuildings.map<Widget>((building) {
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
            }).toList(),
            // what can we build
            ...RESOURCE_BUILDING_TYPES.values.map((value) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: BorderedContainer(
                  child: SlideableButton(
                    child: ResourceBuildingMetaView(type: value),
                    onPress: () {
                      try {
                        city.buildResourceBuildingFromType(value);
                      } catch (e) {
                        print('Cannot build. Missing: $e');
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          ]),
    );
  }
}
