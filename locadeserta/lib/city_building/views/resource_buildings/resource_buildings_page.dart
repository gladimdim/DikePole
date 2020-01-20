import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';
import 'package:locadeserta/city_building/views/resource_buildings/resource_building_built.dart';
import 'package:locadeserta/city_building/views/resource_buildings/resource_building_meta.dart';
import 'package:locadeserta/city_building/views/soft_container.dart';

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...city.resourceBuildings
                .map<Widget>(
                  (building) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SoftContainer(
                      child: SlideableButton(
                        child: Container(
                          height: 64,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.asset(
                                  buildingTypeToIconPath(building.type),
                                ),
                                Text(
                                  buildingTypeToString(building.type),
                                ),
                                Icon(Icons.arrow_right),
                              ],
                            ),
                          ),
                        ),
                        onPress: () {
                          Navigator.pushNamed(
                            context,
                            ResourceBuildingBuilt.routeName,
                            arguments: ResourceBuildingBuiltArguments(
                              city: widget.city,
                              building: building,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
                .toList(),
            // what can we build
            ...RESOURCE_BUILDING_TYPES.values.map((value) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: ResourceBuildingMetaView(
                      type: value,
                      selected: selected == value,
                      onBuildPressed: () {
                        try {
                          city.buildBuilding(ResourceBuilding.fromType(value));
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
              );
            }).toList(),
          ]),
    );
  }
}
