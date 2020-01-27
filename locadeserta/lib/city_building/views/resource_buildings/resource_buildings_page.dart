import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/city_building/inherited_city.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/views/components/built_building_listview.dart';
import 'package:locadeserta/city_building/views/nature_resource_buildings.dart';
import 'package:locadeserta/city_building/views/resource_buildings/resource_building_built.dart';
import 'package:locadeserta/city_building/views/resource_buildings/resource_building_meta.dart';
import 'package:locadeserta/city_building/views/components/soft_container.dart';

class ResourceBuildingsPage extends StatefulWidget {
  @override
  _ResourceBuildingsPageState createState() => _ResourceBuildingsPageState();
}

class _ResourceBuildingsPageState extends State<ResourceBuildingsPage> {
  var selected;

  @override
  Widget build(BuildContext context) {
    var city = InheritedCity.of(context).city;
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...city.naturalResources.map<Widget>((el) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SoftContainer(
                    child: BuiltBuildingListView(
                  title: el.toString(),
                  buildingIconPath: el.getIconPath(),
                  producesIconPath: resourceTypesToImagePath(el.produces),
                  amount: el.outputAmount,
                  onPress: () {
                    Navigator.pushNamed(
                        context, NatureResourceBuildingScreen.routeName,
                        arguments: NatureResourceBuildingArguments(
                          city: city,
                          building: el,
                        ));
                  },
                )),
              );
            }).toList(),
            SizedBox(
              height: 32,
            ),
            ...city.resourceBuildings
                .map<Widget>(
                  (building) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ResourceBuildingBuiltListItemView(
                      building: building,
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
