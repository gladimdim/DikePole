import 'package:flutter/material.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/citizen.dart';

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
            building.produces == CITY_PROPERTIES.CITIZENS
                ? Image.asset(
                    Citizen.getIconPath(),
                    width: 64,
                  )
                : Text(cityPropertiesToString(building.produces)),
          ],
        ),
      ],
    );
  }
}
