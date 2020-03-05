import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/views/city_buildings/city_building_built.dart';
import 'package:sloboda/views/city_buildings/city_building_meta.dart';
import 'package:sloboda/views/components/built_building_listview.dart';

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
                  title: localizedCityBuildingByType(cb.type),
                  buildingIconPath: cityTypeToIconPath(cb.type),
                  producesIconPath: cb.produces.toIconPath(),
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
                (v) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
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
                          final snackBar = SnackBar(
                              content: Text(
                                  'Cannot build. Missing: ${e.toLocalizedString()}'));
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
