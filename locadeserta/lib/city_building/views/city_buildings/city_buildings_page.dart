import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/city_building/inherited_city.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
import 'package:locadeserta/city_building/views/city_buildings/city_building_built.dart';
import 'package:locadeserta/city_building/views/city_buildings/city_building_meta.dart';

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
          ...city.cityBuildings
              .map(
                (cb) => CityBuildingBuiltListItemView(
                  building: cb,
                ),
              )
              .toList(),
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
