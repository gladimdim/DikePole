import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/citizen.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
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
    city.resourceBuildings.add(ResourceBuilding.fromType(BUILDING_TYPES.FIELD));
    city.resourceBuildings.add(ResourceBuilding.fromType(BUILDING_TYPES.MILL));
  }

  @override
  Widget build(BuildContext context) {
    var resourceFieldsColumn = city.resourceBuildings.map<Widget>((building) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                building.removeWorker();
              });
            },
          ),

            Row(
              children: [
                Text(
                  buildingTypeToString(building.type),
                ),
                Text(': +${building.output()} ${resourceTypesToString(building.produces)}'),
                if (building.hasWorkers())
                Text('( ${building.amountOfWorkers()} '),
                if (building.hasWorkers())
                Icon(Icons.person),
                if (building.hasWorkers())
                Text(')'),
              ],
            ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                building.addWorker(Citizen());
              });
            },
          )
        ],
      );
    }).toList();
    resourceFieldsColumn.add(
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
          child: BorderedContainer(
            child: SlideableButton(
              child: FatContainer(text: "Add Field"),
              onPress: () {
                setState(() {
                  city.resourceBuildings
                      .add(ResourceBuilding.fromType(BUILDING_TYPES.FIELD));
                });
              },
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: BorderedContainer(
            child: SlideableButton(
              child: FatContainer(text: "Remove Field"),
              onPress: () {
                setState(() {
                  city.removeResourceBuildingByType(BUILDING_TYPES.FIELD);
                });
              },
            ),
          ),
        )
      ]),
    );
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: resourceFieldsColumn),
      ),
    );
  }
}
