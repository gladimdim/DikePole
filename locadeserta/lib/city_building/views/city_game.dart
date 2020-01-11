import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';
import 'package:locadeserta/city_building/views/city_dashboard.dart';
import 'package:locadeserta/city_building/views/resource_buildings_page.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/models/Localizations.dart';

class CityGame extends StatefulWidget {
  static const routeName = "/city_game";

  @override
  _CityGameState createState() => _CityGameState();
}

class _CityGameState extends State<CityGame> {
  Sloboda city;

  @override
  initState() {
    super.initState();
    city = Sloboda();
    city.name = 'Dimitrova';
    city.resourceBuildings.add(ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.FIELD));
    city.resourceBuildings.add(ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.MILL));
  }

  @override
  Widget build(BuildContext context) {

    return NarrowScaffold(
      title: 'Sloboda',
      actions: [
        AppBarObject(
            text: LDLocalizations.backToMenu,
            onTap: () {
              Navigator.pop(context);
            })
      ],
      body: FractionallySizedBox(
        heightFactor: 1,
        widthFactor: 1,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 2,
          itemBuilder: (context, index) {
            if (index == 1) {
              return ResourceBuildingsPage(city: city);
            } else {
              return CityDashboard(city:  city,);
            }
          }
          ,
        ),
      ),
    );
  }
}
