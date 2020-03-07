import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/views/components/built_building_listview.dart';
import 'package:sloboda/views/nature_resource_buildings.dart';
import 'package:sloboda/views/resource_buildings/resource_building_built.dart';
import 'package:sloboda/views/resource_buildings/resource_building_meta.dart';

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
              return Container(
                padding: EdgeInsets.all(8.0),
                child: BuiltBuildingListView(
                  title: el.toLocalizedString(),
                  buildingIconPath: el.getIconPath(),
                  producesIconPath: el.produces.toIconPath(),
                  amount: el.outputAmount,
                  onPress: () {
                    Navigator.pushNamed(
                        context, NatureResourceBuildingScreen.routeName,
                        arguments: NatureResourceBuildingArguments(
                          city: city,
                          building: el,
                        ));
                  },
                ),
              );
            }).toList(),
            VDivider(),
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
              var building = ResourceBuilding.fromType(value);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: ResourceBuildingMetaView(
                      building: building,
                      selected: selected == value,
                      onBuildPressed: () {
                        try {
                          city.buildBuilding(building);
                        } catch (e) {
                          final snackBar = SnackBar(
                              content: Text(
                                  'Cannot build. Missing: ${e.toLocalizedString()}'));
                          Scaffold.of(context).showSnackBar(snackBar);
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
