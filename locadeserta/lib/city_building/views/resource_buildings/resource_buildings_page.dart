import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';
import 'package:locadeserta/city_building/views/resource_buildings/resource_building_built.dart';
import 'package:locadeserta/city_building/views/resource_buildings/resource_building_meta.dart';
import 'package:locadeserta/components/bordered_container.dart';

class ResourceBuildingsPage extends StatefulWidget {
  final Sloboda city;

  ResourceBuildingsPage({this.city});

  @override
  _ResourceBuildingsPageState createState() => _ResourceBuildingsPageState();
}

class _ResourceBuildingsPageState extends State<ResourceBuildingsPage> {
  var selected;

  @override
  Widget build(BuildContext context) {
    var city = widget.city;
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Resource Buildings',
              style: TextStyle(fontSize: 30),
            ),
            ...city.resourceBuildings
                .map<Widget>((building) => ResourceBuildingBuilt(
                      building: building,
                      city: city,
                    ))
                .toList(),
            // what can we build
            ...RESOURCE_BUILDING_TYPES.values.map((value) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: BorderedContainer(
                  child: InkWell(
                    child: ResourceBuildingMetaView(
                        type: value,
                        selected: selected == value,
                        onBuildPressed: () {
                          try {
                            city.buildResourceBuildingFromType(value);
                          } catch (e) {
                            print('Cannot build. Missing: $e');
                          }
                        }),
                    onTap: () {
                      setState(() {
                        if (selected == value) {
                          selected = null;
                        } else {
                          selected = value;
                        }
                      });
                    },
                  ),
                ),
              );
            }).toList(),
          ]),
    );
  }
}
