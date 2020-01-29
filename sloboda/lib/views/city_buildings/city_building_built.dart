import 'package:flutter/material.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/views/city_buildings/city_building_output_view.dart';
import 'package:sloboda/views/components/built_building_listview.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/components/app_bar_custom.dart';
import 'package:sloboda/components/narrow_scaffold.dart';

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

class CityBuildingBuilt extends StatefulWidget {
  final CityBuilding building;
  final Sloboda city;
  static final String routeName = '/city_building/city_building';

  CityBuildingBuilt({this.building, this.city});

  @override
  _ResourceBuildingBuiltState createState() => _ResourceBuildingBuiltState();
}

class _ResourceBuildingBuiltState extends State<CityBuildingBuilt> {
  @override
  Widget build(BuildContext context) {
    var city = widget.city;
    var building = widget.building;
    return NarrowScaffold(
      title: cityBuildingTypeToString(building.type),
      actions: [
        AppBarObject(
          text: 'Back',
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SoftContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SoftContainer(
                      child: Image.asset(
                        cityTypeToIconPath(building.type),
                        height: 320,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SoftContainer(
                      child: CityBuildingOutputView(
                        building: building,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    height: 64,
                    child: SoftContainer(
                      child: SlideableButton(
                        child: Center(child: Text('Destroy building')),
                        onPress: () {
                          city.removeCityBuilding(building);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CityBuildingBuiltArguments {
  final Sloboda city;
  final CityBuilding building;

  CityBuildingBuiltArguments({this.city, this.building});
}

class ExtractCityBuildingBuiltArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final CityBuildingBuiltArguments args =
        ModalRoute.of(context).settings.arguments;

    return CityBuildingBuilt(
      city: args.city,
      building: args.building,
    );
  }
}
