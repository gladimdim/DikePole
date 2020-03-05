import 'package:flutter/material.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/sloboda_localizations.dart';

class CityBuildingOutputView extends StatelessWidget {
  final CityBuilding building;

  CityBuildingOutputView({this.building});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(SlobodaLocalizations.output),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            building.produces == CITY_PROPERTIES.CITIZENS
                ? Image.asset(
                    Citizen.getIconPath(),
                    width: 64,
                  )
                : Text(
                    building.produces.toLocalizedString(),
                  ),
          ],
        ),
      ],
    );
  }
}
