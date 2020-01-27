import 'package:flutter/material.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';

class CityBuildingOutputView extends StatelessWidget {
  final CityBuilding building;

  CityBuildingOutputView({this.building});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Output'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(cityPropertiesToString(building.produces)),
          ],
        ),
      ],
    );
  }
}
