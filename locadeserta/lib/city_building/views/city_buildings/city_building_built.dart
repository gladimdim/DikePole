import 'package:flutter/material.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
import 'package:locadeserta/city_building/views/components/built_building_listview.dart';

class CityBuildingBuiltListItemView extends StatelessWidget {
  final CityBuilding building;

  CityBuildingBuiltListItemView({this.building});

  @override
  Widget build(BuildContext context) {
    return BuiltBuildingListView(
      title: cityBuildingTypeToString(building.type),
      buildingIconPath: cityTypeToIconPath(building.type),
      producesIconPath: cityPropertiesToIconPath(building.produces),
      amount: 1,
    );
  }
}
