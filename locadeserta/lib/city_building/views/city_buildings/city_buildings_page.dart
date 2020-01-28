import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/city_building/inherited_city.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
import 'package:locadeserta/city_building/views/city_buildings/city_building_built.dart';
import 'package:locadeserta/city_building/views/city_buildings/city_building_meta.dart';
import 'package:locadeserta/city_building/views/components/built_building_listview.dart';

class CityBuildingsPage extends StatefulWidget {
  @override
  _CityBuildingsPageState createState() => _CityBuildingsPageState();
}

class _CityBuildingsPageState extends State<CityBuildingsPage> {
  CITY_BUILDING_TYPES selected;

  @override
  Widget build(BuildContext context) {
    var city = InheritedCity.of(context).city;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...city.cityBuildings.map(
            (cb) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: BuiltBuildingListView(
                  title: cityBuildingTypeToString(cb.type),
                  buildingIconPath: cityTypeToIconPath(cb.type),
                  producesIconPath: cityPropertiesToIconPath(cb.produces),
                  amount: 1,
                  onPress: () {
                    Navigator.pushNamed(context, CityBuildingBuilt.routeName,
                        arguments: CityBuildingBuiltArguments(
                          city: city,
                          building: cb,
                        ));
                  },
                ),
              );
            },
          ).toList(),
          ...CITY_BUILDING_TYPES.values
              .map(
                (v) => InkWell(
                  onTap: () {
                    setState(() {
                      if (selected == v) {
                        selected = null;
                      } else {
                        selected = v;
                      }
                    });
                  },
                  child: CityBuildingMetaView(
                    type: v,
                    selected: selected == v,
                    onBuildPressed: () {
                      try {
                        city.buildBuilding(CityBuilding.fromType(v));
                      } catch (e) {
                        print('Cannot build. Missing: $e');
                      }
                    },
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
